class ApplicationController < ActionController::Base
  include Devised

  COLLECTION_ACTIONS = %w(index)
  GROUPABLE_ACTIONS = %w(index new create)
  CONTEXTUAL_ACTIONS = COLLECTION_ACTIONS + %w(show)

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  prepend_view_path Rails.root.join('frontend')

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_member!
  around_action :set_timezone
  
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, alert: 'You are not authorized to complete that action.'
  end

  protected

    def dump_exception(e)
      return unless Rails.env.development?
      puts "EXCEPTION: #{e}"
      e.backtrace.each {|l| puts l}
    end

    def is_collection_action?
      self.class::COLLECTION_ACTIONS.include?(self.action_name)
    end

    def is_contextual_action?
      self.class::CONTEXTUAL_ACTIONS.include?(self.action_name)
    end
    
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def set_timezone(&block)
      time_zone = member_signed_in? ? current_member.time_zone : TheGatherings::Application.default_time_zone
      Time.use_zone(time_zone, &block)
    end

end
