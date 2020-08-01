module BackendScript
  class QuestionSearchScript < ::BackendScript::Base
    include SortMod
    include TargeQuestionsMethods

    self.category = "actb"
    self.script_name = "問題検索"

    def form_parts
      super + [
        {
          :label   => "タイトル",
          :key     => :query,
          :type    => :string,
          :default => current_query,
        },
      ]
    end

    def script_body
      s = Actb::Question.all
      if v = current_target_question_ids.presence
        s = s.where(id: v)
      end
      if v = current_query
        s = s.where(["title like ?", "%#{v}%"])
      end
      s = sort_scope(s)
      s = page_scope(s)
      rows = s.collect(&method(:row_build))

      if rows.one?
        return rows.first
      end

      out = "".html_safe
      out << rows.to_html
      out << basic_paginate(s)
    end

    def row_build(question)
      row = {}
      row.update(question.info)
      row["ID"] = question_link_to(question.id, question)
      row["タイトル"] = question_link_to(question.title, question)
      row["投稿者"] = user_link_to(question.user.name, question.user)

      row["詳細URL"]    = h.link_to("詳細", row["詳細URL"])
      row["画像URL"]    = h.link_to("画像", row["画像URL"])
      row["共有将棋盤"] = h.link_to("盤", row["共有将棋盤"])

      row.update("操作" => [
          # h.link_to("ミュート", QuestionMuteScript.script_link_path(target_user_ids: user.id)),
          h.link_to("削除", QuestionDestroyScript.script_link_path(target_question_ids: question.id)),
        ].join(" ").html_safe)
      row
    end

    def current_query
      params[:query].to_s.strip.presence
    end
  end
end
