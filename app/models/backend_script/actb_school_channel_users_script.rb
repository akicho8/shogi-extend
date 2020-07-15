module BackendScript
  class ActbSchoolChannelUsersScript < ::BackendScript::Base
    self.category = "actb"
    self.script_name = "将棋トレバト オンラインユーザー"

    def script_body
      if Rails.env.development?
        Actb::SchoolChannel.active_users_add_all
        Actb::RoomChannel.active_users_add_all
      end

      users = Actb::SchoolChannel.active_users.reverse
      users.collect(&method(:row_build))
    end

    def row_build(user)
      {
        "ID"       => user.id,
        "名前"     => user.name,
        "対戦中"   => Actb::RoomChannel.active_users.include?(user) ? "○" : "",
        "ルール"   => user.actb_setting.rule.pure_info.name,
        "登録日時" => user.created_at.to_s(:distance),
      }
    end
  end
end
