class WelcomeController < ApplicationController
  include Sequencer

  sequence_of :signup, :age_group, :life_stage, :relationship, :gender, :connected, klass: :member

  skip_before_action :authenticate_member!, only: [:index]

  # POST /welcome/signup/:id/connected
  # POST /welcome/signup/:id/connected.json
  def sequence_complete_connected_step
    # TODO: Post get connected job as necessary
    # TODO: Send reset password link to supplied email
    redirect_to welcome_signup_url
  end

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
      if (1...self.class.sequence_steps.length-1).include?(@sequence_step_index)
        @collection = @welcome.class.send("#{@sequence_step}s_collection".to_sym)
        @collection_member = "#{@sequence_step}_list".to_sym
      end
    end

    def sequence_variable_factory
      Member.new
    end

end
