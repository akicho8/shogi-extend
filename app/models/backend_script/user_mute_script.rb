module BackendScript
  class UserMuteScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod
    include TargeUsersMethods

    self.category = "actb"
    self.script_name = "ユーザーミュート(current_userに登録)"

    # def form_parts
    #   [
    #     {
    #       :label   => "ユーザー",
    #       :key     => :user_id,
    #       :type    => :string,
    #       :default => current_user&.id,
    #     },
    #   ] + super
    # end

    def script_body
      if current_user
        current_target_users.each do |target|
          if current_user.mute_users.include?(target)
            current_user.mute_users.destroy(target)
          else
            current_user.mute_users << target
          end
        end
        current_user.mute_users
      end
    end
  end
end
