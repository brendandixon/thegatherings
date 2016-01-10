class WelcomeController < ApplicationController
  include Sequencer

  sequence_of :signup, :age_group, :life_stage, :relationship, :gender, :connected, klass: :member

  skip_before_action :authenticate_member!, only: [:index]

  def sequence_complete_connected_step
    # TODO: Post get connected job as necessary
    # TODO: Send reset password link to supplied email
  end

  def sequence_complete
    respond_to do |format|
      format.html { redirect_to welcome_signup_url }
    end    
  end

  private

    def sequence_step_params
      case @sequence_step
      when :signup
        params.require(:member).permit(:email, :first_name, :last_name, :phone, :postal_code)
      when :connected
      else
        params.require(:member).permit("#{@sequence_step}_list".to_sym => [])
      end
    end

    def sequence_prepare_step
      if (1...self.class.sequence_steps.length-1).include?(@sequence_step_index)
        @collection = @member.class.send("#{@sequence_step}s_collection".to_sym)
        @collection_member = "#{@sequence_step}_list".to_sym
      end
    end

    def sequence_variable_factory
      Member.new
    end

end
