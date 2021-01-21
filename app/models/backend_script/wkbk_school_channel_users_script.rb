module BackendScript
  class WkbkSchoolChannelUsersScript < ::BackendScript::Base
    self.category = "wkbk"
    self.script_name = "将棋トレバト オンラインユーザー"

    def script_body
      if Rails.env.development?
        Wkbk::SchoolChannel.active_users_add_all
        Wkbk::RoomChannel.active_users_add_all
      end

      users = Wkbk::SchoolChannel.active_users.reverse
      users.collect(&method(:row_build))
    end

    def row_build(user)
      {
        "ID"       => user.id,
        "名前"     => user.name,
        "対戦中"   => Wkbk::RoomChannel.active_users.include?(user) ? "○" : "",
        "ルール"   => user.wkbk_setting.rule.pure_info.name,
        "登録日時" => user.created_at.to_s(:distance),
      }
    end
  end
end
