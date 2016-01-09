class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :authenticate_member!
  around_filter :set_timezone

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |m|
      m.permit(:email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code)
    end
    devise_parameter_sanitizer.for(:account_update) do |m|
      m.permit(:current_password, :email, :first_name, :last_name, :password, :password_confirmation, :phone, :postal_code)
    end
  end
   
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_timezone(&block)
    time_zone = member_signed_in? ? current_member.time_zone : TheGatherings::Application.default_time_zone
    Time.use_zone(time_zone, &block)
  end

end
