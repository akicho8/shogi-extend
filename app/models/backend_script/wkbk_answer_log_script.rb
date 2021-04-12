module BackendScript
  class WkbkAnswerLogScript < ::BackendScript::Base
    include SortMethods

    self.category = "wkbk"
    self.script_name = "インスタント将棋問題集 解答履歴"

    def script_body
      s = Wkbk::AnswerLog.all
      s = sort_scope(s)
      s = page_scope(s)

      rows = s.collect(&method(:row_build))

      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(record)
      {
        "ID"     => record.id,
        "回答者" => user_link_to(record.user.name, record.user),
        "問題集" => book_link_to(record.book),
        "問題"   => article_link_to(record.article),
        "時間"   => record.spent_sec,
        "解答"   => record.answer_kind.mark,
        "日時"   => record.created_at.to_s(:distance),
      }
    end
  end
end
