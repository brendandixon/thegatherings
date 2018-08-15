class Member::RegistrationsController < Devise::RegistrationsController
  include Devised

  layout 'plain', only: :signup
  respond_to :json

  prepend_before_action :authenticate_scope!, only: [:show, :edit, :update, :destroy]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # def show
  # end

  # POST /resource
  # def create
  #     super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def signup
    @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    @community ||= @campus.community if @campus.present?
    @completed_path = signup_params[:mode] == 'single' ? request.referrer : nil
  end

  # Override Devise automatic sign-in after registration
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource) unless current_member.present?
  end

  protected

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      logger.debug "HERE!!!! #{resource.inspect} -- #{member_path(resource)}"
      member_path(resource)
    end

    # The path used after sign up for inactive accounts.
    def after_inactive_sign_up_path_for(resource)
      member_path(resource)
    end

    # The default url to be used after updating a resource.
    def after_update_path_for(resource)
      member_path(resource)
    end

    # By default we want to require a password checks on update.
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def signup_params
      params.permit(:campus_id, :community_id, :mode)
    end

end
