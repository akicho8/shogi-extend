module BackendScript
  class RecentlyUserScript < ::BackendScript::Base
    self.category = "ツール"
    self.script_name = "直近利用ユーザー"

    def script_body
      records.collect do |e|
        {
          "ウォーズID" => e.name_with_grade,
          "回数"       => e.search_logs_count,
          "最終利用"   => e.last_reception_at&.to_s(:distance),
        }
      end
    end

    def records
      Swars::User.recently_only.limit(100)
    end
  end
end
