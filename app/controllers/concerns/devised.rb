module Devised
  extend ActiveSupport::Concern

  ACCOUNT_KEYS = [:email, :first_name, :gender, :last_name, :phone, :postal_code]
  SIGNUP_KEYS = ACCOUNT_KEYS + [:password, :password_confirmation]
  UPDATE_KEYS = SIGNUP_KEYS + [:current_password]

  protected

    def after_sign_in_path_for(member)
      dashboard_path
    end

    def after_sign_out_path_for(member)
      signin_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: UPDATE_KEYS)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: SIGNUP_KEYS)
      devise_parameter_sanitizer.permit(:account_update, keys: UPDATE_KEYS)
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: SIGNUP_KEYS)
    end

end