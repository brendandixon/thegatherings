class WelcomeController < ApplicationController

  skip_before_action :authenticate_member!, only: [:show]

  def show
    if member_signed_in?
      redirect_to dashboard_path
    else
      render
    end
  end

end
