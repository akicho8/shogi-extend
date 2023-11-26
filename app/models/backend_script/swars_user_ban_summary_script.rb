module BackendScript
  class SwarsUserBanSummaryScript < ::BackendScript::Base
    self.category = "swars"
    self.script_name = "棋譜検索 ユーザー 垢BAN リスト"

    def form_parts
      [
        {
          :label   => "表示",
          :key     => :custom,
          :type    => :check_box,
          :elems   => ["ウォーズID"],
          :default => current_custom.to_a,
        }
      ]
    end

    def script_body
      s = Swars::User.all
      s = s.ban_only
      s = s.great_only
      s.select("COUNT(*) AS count_all, grade_id").group("grade_id").collect do |e|
        grade = Swars::Grade.find(e.grade_id)
        row = {}
        row["段級位"] = grade.name
        row["人数"]   = e.count_all
        if current_custom.include?("ウォーズID")
          row["ウォーズID"] = id_list(grade)
        end
        row
      end
    end

    def id_list(grade)
      Swars::User.ban_only.where(grade: grade).collect { |user|
        h.link_to(user.key, UrlProxy.full_url_for("/swars/search?query=#{user.key}"))
      }.join(" ").html_safe
    end

    def current_custom
      Array(params[:custom]).to_set
    end
  end
end
