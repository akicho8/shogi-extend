module BackendScript
  class WkbkArticleScript < ::BackendScript::Base
    include SortMethods

    self.category = "wkbk"
    self.script_name = "インスタント将棋問題集 問題"

    def script_body
      s = Wkbk::Article.all
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
        "KEY"      => record.key,
        "問題"     => article_link_to(record),
        "公開設定" => record.folder.name,
        "問題集"   => record.books.collect { |e| book_link_to(e) }.join("<br>").html_safe,
        "作成者"   => h.link_to(record.user.name, UrlProxy.wrap2("/users/#{record.user.id}")),
        "解数"     => record.moves_answers.count,
        "難易度"   => record.difficulty,
        "種類"     => record.lineage.name,
        "作成日時" => record.created_at.to_s(:distance),
      }
    end
  end
end
