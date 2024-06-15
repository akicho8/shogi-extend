module BackendScript
  class SwarsUserStatBadgeStatScript < ::BackendScript::Base
    include SwarsIdMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜 バッジ一覧の計算時間の確認"

    def script_body
      if user = Swars::User.find_by(user_key: current_swars_id)
        stat = user.stat(sample_max: 200)
        stat.ids_scope.to_a # 最も重い共通処理を実行済みにしておく
        stat.badge_stat.execution_time_explain
      end
    end
  end
end
