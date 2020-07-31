module BackendScript
  class MuteUserScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod

    self.category = "actb"
    self.script_name = "将棋トレバト ミュート"

    def form_parts
      [
        {
          :label   => "対象ユーザー",
          :key     => :target_ids,
          :type    => :string,
          :default => current_target_ids,
        },
      ]
    end

    def script_body
      if h.current_user
        current_targets.each do |target|
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

    def current_target_ids
      params[:target_ids].to_s.scan(/\d+/).collect(&:to_i)
    end

    def current_targets
      if v = current_target_ids
        User.find(v)
      end
    end
  end
end
