module Api
  class SessionsController < ::Api::ApplicationController
    # http://localhost:3000/api/session/current_user_fetch
    def current_user_fetch
      if current_user
        render json: current_user.as_json_public_profile
      end
    end
  end
end
