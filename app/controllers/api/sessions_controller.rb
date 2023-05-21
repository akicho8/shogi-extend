module Api
  class SessionsController < ::Api::ApplicationController
    # curl http://localhost:3000/api/session/auth_user_fetch
    def auth_user_fetch
      attrs = nil
      if current_user
        attrs = current_user.as_json_simple_public_profile
      end
      render json: attrs
    end

    # Vuex をからめたら戻値の受け取り方がわからなくなったため戻値は未使用
    # curl -d _method=delete http://localhost:3000/api/session/auth_user_logout
    # current_user_clear にすると無限ループになるので注意
    def auth_user_logout
      if current_user
        current_user_clear
      end
      if current_user
        render json: { xnotice: Xnotice.add("ログアウトできていません", type: "is-danger", method: :dialog) } # 戻値未使用
      else
        render json: { xnotice: Xnotice.add("ログアウトしました", type: "is-success") } # 戻値未使用
      end
    end

    # curl -d _method=delete http://localhost:3000/api/session/auth_user_destroy
    def auth_user_destroy
      if !current_user
        raise "must not happen"
      end
      auth_user_destroy_notify
      if params[:fake]
      else
        current_user.destroy!
        current_user_clear
      end
      render json: { message: "ok" } # 戻値未使用
    end

    private

    def auth_user_destroy_notify
      subject = []
      subject << "【退会】#{current_user.name}"
      if Rails.env.development?
        subject << params.to_unsafe_h.slice(:fake).inspect
      end
      subject = subject.join(" ")
      AppLog.important(subject: subject, body: current_user.info.to_t)
    end
  end
end
