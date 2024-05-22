module BackendScript
  class SwarsUserInfoMedalListTimeStatsScript < ::BackendScript::Base
    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜 メダル一覧の計算時間の確認"

    def form_parts
      super + [
        {
          :label   => "対象のウォーズID",
          :key     => :user_key,
          :type    => :string,
          :default => params[:user_key] || "SugarHuuko",
        },
      ]
    end

    def script_body
      if user = Swars::User.find_by(user_key: current_user_key)
        user.user_info(sample_max: 200).medal_list.time_stats
      end
    end

    def current_user_key
      params[:user_key].to_s
    end
  end
end
