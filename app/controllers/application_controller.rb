class ApplicationController < ActionController::Base

  COLLECTION_ACTIONS = %w(index)
  GROUPABLE_ACTIONS = %w(index new create)
  SCOPED_ACTIONS = COLLECTION_ACTIONS + %w(show)

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :authenticate_member!
  around_filter :set_timezone
  
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, alert: 'You are not authorized to complete that action.'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |m|
      m.permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code)
    end
    devise_parameter_sanitizer.for(:account_update) do |m|
      m.permit(:current_password, :email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code)
    end
  end

  def is_collection_action?
    self.class::COLLECTION_ACTIONS.include?(self.action_name)
  end

  def is_scoped_action?
    self.class::SCOPED_ACTIONS.include?(self.action_name)
  end
   
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_timezone(&block)
    time_zone = member_signed_in? ? current_member.time_zone : TheGatherings::Application.default_time_zone
    Time.use_zone(time_zone, &block)
  end

end
