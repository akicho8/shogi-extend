module BackendScript
  class UserSwitchDirectScript < ::BackendScript::Base
    self.category = "ユーザー"
    self.script_name = "運営切り替え (直接)"
    self.visibility_hidden = true

    def script_body
      if params[:user_key]
        user = User.find_by!(key: params[:user_key])
        c.current_user_set(user)
        c.redirect_to params[:redirect_to]
      end
    end
  end
end
