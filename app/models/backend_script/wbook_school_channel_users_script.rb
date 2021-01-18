module BackendScript
  class WbookSchoolChannelUsersScript < ::BackendScript::Base
    self.category = "wbook"
    self.script_name = "将棋トレバト オンラインユーザー"

    def script_body
      if Rails.env.development?
        Wbook::SchoolChannel.active_users_add_all
        Wbook::RoomChannel.active_users_add_all
      end

      users = Wbook::SchoolChannel.active_users.reverse
      users.collect(&method(:row_build))
    end

    def row_build(user)
      {
        "ID"       => user.id,
        "名前"     => user.name,
        "対戦中"   => Wbook::RoomChannel.active_users.include?(user) ? "○" : "",
        "ルール"   => user.wbook_setting.rule.pure_info.name,
        "登録日時" => user.created_at.to_s(:distance),
      }
    end
  end
end
