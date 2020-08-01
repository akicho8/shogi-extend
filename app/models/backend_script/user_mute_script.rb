module BackendScript
  class UserMuteScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod

    self.category = "actb"
    self.script_name = "ユーザーミュート"

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
      if h.current_user
        current_target_users.each do |target|
          if h.current_user.mute_users.include?(target)
            h.current_user.mute_users.destroy(target)
          else
            h.current_user.mute_users << target
          end
        end
        h.current_user.mute_users
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
