class Member::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  before_action :set_member

  layout 'plain'
  respond_to :json

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    if @member == current_member
      super
    else
      respond_to do |format|
        format.html {
          flash[:notice] = 'Ignored signout request'
          redirect_back fallback_location: member_root_path, status: :unauthorized
        }
        format.json { render json: {errors: {base: 'Ignored signout request'}}, status: :ok}
      end
    end
  end

  protected

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
      @member ||= current_member
    end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
