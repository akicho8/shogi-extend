class LoginController < ApplicationController
  # http://localhost:3000/login?return_to=http://localhost:4000/xy
  # http://localhost:3000/login?return_to=http://localhost:4000/xy&social_media_key=twitter
  def show
    path = :new_xuser_session

    if v = params[:return_to]
      session[:return_to] = v
    end

    if v = params[:social_media_key]
      path = omniauth_authorize_path("xuser", v)
    end

    redirect_to path
  end
end
