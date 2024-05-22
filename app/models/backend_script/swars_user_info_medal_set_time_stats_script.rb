module BackendScript
  class SwarsUserInfoMedalSetTimeStatsScript < ::BackendScript::Base
    self.category = "swars"
    self.script_name = "将棋ウォーズ棋譜 メダル一覧の計算時間の確認"

    def form_parts
      super + [
        {
          :label   => "対象のウォーズID",
          :key     => :swars_id,
          :type    => :string,
          :default => params[:swars_id] || current_swars_id_default,
        },
      ]
    end

    def script_body
      if user = Swars::User.find_by(user_key: current_swars_id)
        user.user_info(sample_max: 200).medal_set.time_stats
      end
    end

    def current_swars_id
      params[:swars_id].to_s
    end

    def current_swars_id_default
      case Rails.env
      when "development", "test"
        Swars::User.first&.user_key
      else
        "SugarHuuko"
      end
    end
  end
end
