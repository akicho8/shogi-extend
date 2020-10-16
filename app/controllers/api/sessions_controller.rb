module Api
  class SessionsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/session/current_user_fetch
    def current_user_fetch
      if current_user
        render json: current_user.as_json_simple_public_profile
      end
    end

    # curl -d _method=delete http://localhost:3000/api/session/current_user_clear_action
    # current_user_clear にすると無限ループになるので注意
    def current_user_clear_action
      if current_user
        current_user_clear
      end
      render json: { status: :success }
    end
  end
end
