module BackendScript
  class ActbRoomScript < ::BackendScript::Base
    include SortMod

    self.category = "actb"
    self.script_name = "将棋トレバト 対戦部屋リスト"

    def script_body
      s = Actb::Room.all
      s = sort_scope(s)
      s = page_scope(s)

      rows = s.collect(&method(:row_build))

      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ID"        => record.id,
        "ルール"    => record.rule.name,
        "回数"      => record.battles_count,
        "練習"      => record.bot_user_id? ? "○" : "",
        "ユーザー"  => record.memberships.collect { |e| h.link_to(e.user.name, [:training, user_id: e.user.id], target: "_blank") }.join(" vs ").html_safe,
        "日時"      => record.created_at.to_s(:distance),
      }
    end
  end
end
