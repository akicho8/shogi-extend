module BackendScript
  class SwarsRecentlyUserScript < ::BackendScript::Base
    self.category = "swars"
    self.script_name = "棋譜検索 直近利用ユーザー"

    def script_body
      records.collect do |e|
        {
          "ウォーズID" => e.name_with_grade,
          "回数"       => e.search_logs.count,
          "最終利用"   => e.last_reception_at&.to_fs(:distance),
        }
      end
    end

    def records
      Swars::User.recently_only.limit(100)
    end
  end
end
