module BackendScript
  class EmoxSchoolChannelUsersScript < ::BackendScript::Base
    self.category = "emox"
    self.script_name = "エモ将棋 オンラインユーザー"

    def script_body
      if Rails.env.development?
        Emox::SchoolChannel.active_users_add_all
        Emox::RoomChannel.active_users_add_all
      end

      users = Emox::SchoolChannel.active_users.reverse
      users.collect(&method(:row_build))
    end

    def row_build(user)
      {
        "ID"       => user.id,
        "名前"     => user.name,
        "対戦中"   => Emox::RoomChannel.active_users.include?(user) ? "○" : "",
        "ルール"   => user.emox_setting.rule.pure_info.name,
        "登録日時" => user.created_at.to_s(:distance),
      }
    end
  end
end
