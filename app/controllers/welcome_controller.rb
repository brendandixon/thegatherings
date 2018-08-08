class WelcomeController < ApplicationController

  skip_before_action :authenticate_member!, only: [:index]

  def show
    render
  end

end
