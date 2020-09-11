class LoginController < ApplicationController
  def show
    if return_to = params[:return_to]
      session[:return_to] = return_to
    end
    redirect_to :new_xuser_session
  end
end
