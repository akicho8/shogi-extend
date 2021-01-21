module BackendScript
  class WkbkRoomMessageSearchScript < ::BackendScript::Base
    self.category = "wkbk"
    self.script_name = "将棋トレバト 対戦部屋 発言"

    def script_body
      s = Wkbk::RoomMessage.all
      s = s.order(created_at: :desc)
      s = s.where(["body NOT like ?", "*%"])
      s = page_scope(s)

      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ID": record.id,
        "名前": "#{record.user.name}(ID:#{record.user.id})",
        "発言": record.body,
        "日時": record.created_at.to_s(:distance),
      }
    end

    def default_per
      100
    end
  end
end
