module BackendScript
  class SwarsUserStatMedalStatScript < ::BackendScript::Base
    include SwarsIdMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜 メダル一覧の計算時間の確認"

    def script_body
      if user = Swars::User.find_by(user_key: current_swars_id)
        user_stat = user.user_stat(sample_max: 200)
        user_stat.ids_scope.to_a # 最も重い共通処理を実行済みにしておく
        user_stat.medal_stat.time_stats
      end
    end
  end
end
