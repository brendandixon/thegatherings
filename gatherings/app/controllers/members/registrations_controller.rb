class Members::RegistrationsController < Devise::RegistrationsController
  include Sequencer

  sequence_of :signup, :age_group, :life_stage, :relationship, :gender, klass: :member

# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  def sequence_complete_signup_step
    sign_in(:member, @member)
  end

  def sequence_complete
    # TODO: Post get connected job as necessary
    respond_to do |format|
      format.html { redirect_to community_gatherings_url(Community.first) }
    end    
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

    def sequence_step_params
      case @sequence_step
      when :signup
        params.require(:member).permit(:email, :first_name, :last_name, :phone, :postal_code)
      when :connected
        params.permit(:connected)
      else
        params.require(:member).permit("#{@sequence_step}_list".to_sym => [])
      end
    end

    def sequence_prepare_step
      if (1...self.class.sequence_steps.length).include?(@sequence_step_index)
        @collection = @member.class.send("#{@sequence_step}s_collection".to_sym)
        @collection_member = "#{@sequence_step}_list".to_sym
      end
    end

    def sequence_variable_factory
      Member.new
    end
end
