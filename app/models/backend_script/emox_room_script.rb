module BackendScript
  class EmoxRoomScript < ::BackendScript::Base
    include SortMod

    self.category = "emox"
    self.script_name = "エモ将棋 対戦部屋リスト"

    def script_body
      s = Emox::Room.all
      s = sort_scope(s)
      s = page_scope(s)

      rows = s.collect(&method(:row_build))

      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ユーザー" => record.memberships.collect { |e| e.user.name }.join(" vs ").html_safe,
        "ルール"   => record.rule.name,
        "日時"     => record.created_at.to_s(:distance),
      }
    end
  end
end
