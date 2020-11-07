class LoginController < ApplicationController
  # http://0.0.0.0:3000/login?return_to=http://0.0.0.0:4000/xy
  # http://0.0.0.0:3000/login?return_to=http://0.0.0.0:4000/xy&social_media_key=twitter
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
