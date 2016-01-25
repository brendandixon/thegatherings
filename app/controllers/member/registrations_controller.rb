class Member::RegistrationsController < Devise::RegistrationsController
  include MemberSignup

  prepend_before_filter :authenticate_scope!, only: [:show, :edit, :update, :destroy]
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up
  def new
    super
  end

  def show
  end

  # POST /resource
  def create
    begin
      super
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
      resource.errors.add(:email, I18n.t(:not_unique, scope:[:errors, :common])) if e.is_a?(ActiveRecord::RecordNotUnique)
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up).concat([:email, :first_name, :last_name, :phone, :postal_code])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update).concat([:email, :first_name, :last_name, :phone, :postal_code])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    start_signup_for(resource)
    begin_member_signup
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    show_member_registration_path
  end

  # The default url to be used after updating a resource.
  def after_update_path_for(resource)
    show_member_registration_path
  end

  # By default we want to require a password checks on update.
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end
