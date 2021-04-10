module BackendScript
  class SwarsCrawlReservationScript < ::BackendScript::Base
    include SortMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜検索 古い棋譜を補完"

    def script_body
      s = Swars::CrawlReservation.all
      s = sort_scope(s)
      s = page_scope(s)
      rows = s.collect(&method(:row_build))
      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ID"       => record.id,
        "作成者"   => user_link_to(record.user.name, record.user),
        "対象"     => record.target_user_key,
        "通知先"   => record.to_email,
        "添付"     => record.attachment_mode,
        "登録日時" => record.created_at.to_s(:ymdhm),
        "完了日時" => record.processed_at&.to_s(:ymdhm),
      }
    end
  end
end
