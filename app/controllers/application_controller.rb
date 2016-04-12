class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
class ApplicationController < ActionController::Base

  COLLECTION_ACTIONS = %w(index)
  GROUPABLE_ACTIONS = %w(index new create)
  SCOPED_ACTIONS = COLLECTION_ACTIONS + %w(show)

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_member!
  around_action :set_timezone
  
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, alert: 'You are not authorized to complete that action.'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:current_password, :email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code])
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
