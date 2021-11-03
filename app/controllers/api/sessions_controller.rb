module Api
  class SessionsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/session/auth_user_fetch
    def auth_user_fetch
      if current_user
        render json: current_user.as_json_simple_public_profile
      end
    end

    # curl -d _method=delete http://localhost:3000/api/session/auth_user_logout
    # current_user_clear にすると無限ループになるので注意
    def auth_user_logout
      if current_user
        current_user_clear
      end
      if current_user
        render json: { xnotice: Xnotice.add("ログアウトできていません", type: "is-danger", method: :dialog) }
      else
        render json: { xnotice: Xnotice.add("ログアウトしました", type: "is-success") }
      end
    end
  end
end
