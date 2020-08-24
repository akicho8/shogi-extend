module BackendScript
  class XclockSchoolChannelUsersScript < ::BackendScript::Base
    self.category = "xclock"
    self.script_name = "将棋トレバト オンラインユーザー"

    def script_body
      if Rails.env.development?
        Xclock::SchoolChannel.active_users_add_all
        Xclock::RoomChannel.active_users_add_all
      end

      users = Xclock::SchoolChannel.active_users.reverse
      users.collect(&method(:row_build))
    end

    def row_build(user)
      {
        "ID"       => user.id,
        "名前"     => user.name,
        "対戦中"   => Xclock::RoomChannel.active_users.include?(user) ? "○" : "",
        "ルール"   => user.xclock_setting.rule.pure_info.name,
        "登録日時" => user.created_at.to_s(:distance),
      }
    end
  end
end
