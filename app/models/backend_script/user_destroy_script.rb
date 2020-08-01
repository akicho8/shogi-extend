module BackendScript
  class UserDestroyScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod
    include TargeUsersMethods

    self.category = "その他"
    self.script_name = "ユーザー削除"

    def script_body
      current_target_users.collect do |user|
        user.destroy!
        user.destroyed?
      end
    end
  end
end
