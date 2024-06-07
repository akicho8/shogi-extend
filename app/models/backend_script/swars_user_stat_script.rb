module BackendScript
  class SwarsStatScript < ::BackendScript::Base
    include SwarsIdMethods

    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜 プレイヤー情報の計算時間の確認"

    def script_body
      if user = Swars::User.find_by(user_key: current_swars_id)
        user.stat(sample_max: 200).other_stat.time_stats
        # body = user.stat(sample_max: 200).as_json.pretty_inspect
        # h.tag.pre(body, style: "font-family:monospace")
      end
    end
  end
end
