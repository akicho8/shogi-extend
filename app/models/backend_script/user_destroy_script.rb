module BackendScript
  class UserDestroyScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod

    self.category = "actb"
    self.script_name = "ユーザー削除"

    def form_parts
      [
        {
          :label   => "対象ユーザーIDs",
          :key     => :target_user_ids,
          :type    => :string,
          :default => current_target_user_ids,
        },
      ]
    end

    def script_body
      current_target_users.collect do |target|
        target.destroy!
        target.destroyed?
      end
    end

    private

    def current_target_user_ids
      params[:target_user_ids].to_s.scan(/\d+/).collect(&:to_i)
    end

    def current_target_users
      if v = current_target_user_ids
        User.find(v)
      end
    end
  end
end
