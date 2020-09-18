class LoginController < ApplicationController
  # http://0.0.0.0:3000/login?return_to=http://0.0.0.0:4000/xy
  def show
    if return_to = params[:return_to]
      session[:return_to] = return_to
    end
    redirect_to :new_xuser_session
  end
end
