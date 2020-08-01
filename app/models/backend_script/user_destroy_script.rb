module BackendScript
  class UserDestroyScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod
    include TargeUserMethods

    self.category = "actb"
    self.script_name = "ユーザー削除"

    def script_body
      current_target_users.collect do |target|
        target.destroy!
        target.destroyed?
      end
    end
  end
end
