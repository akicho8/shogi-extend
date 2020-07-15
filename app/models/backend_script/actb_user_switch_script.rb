module BackendScript
  class ActbUserSwitchScript < ::BackendScript::Base
    include AtomicScript::PostRedirectMod

    self.category = "actb"
    self.script_name = "将棋トレバト 運営切り替え"

    def form_parts
      [
        {
          :label   => "ユーザー",
          :key     => :user_id,
          :elems   => users_hash,
          :type    => :select,
          :default => c.current_user&.id,
        },
      ]
    end

    def script_body
      user = User.find(params[:user_id])
      c.current_user_set(user)
      c.redirect_to :root, toast_black: "#{user.name}に変更しました"
    end

    private

    def users_hash
      [
        "shogi.extend@gmail.com",
        "shogi.extend+bot@gmail.com",
        "pinpon.ikeda+kinakomochi@gmail.com",
        "pinpon.ikeda+splawarabimochi@gmail.com",
        "shogi.extend+cpu-level1@gmail.com",
      ].inject({}) { |a, email|
        if user = User.find_by(email: email)
          a = a.merge(user.name => user.id)
        end
        a
      }
    end
  end
end
