module Swars
  class DisplayRankInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :display_rank_ten_min,   name: "10分",       short_name: "10分", imode_key: :normal, xmode_key: "野良", rule_key: :ten_min,   rule_wise_win_rate_name: "通常 野良 10分",  },
      { key: :display_rank_three_min, name: "3分",        short_name: "3分",  imode_key: :normal, xmode_key: "野良", rule_key: :three_min, rule_wise_win_rate_name: "通常 野良 3分",   },
      { key: :display_rank_ten_sec,   name: "10秒",       short_name: "10秒", imode_key: :normal, xmode_key: "野良", rule_key: :ten_sec,   rule_wise_win_rate_name: "通常 野良 10秒",  },
      { key: :display_rank_sprint,    name: "スプリント", short_name: "ス",   imode_key: :sprint, xmode_key: "野良", rule_key: :three_min, rule_wise_win_rate_name: "ｽﾌﾟﾘﾝﾄ 野良 3分", },
    ]

    def display_rank_item
      {
        :key           => key,
        :short_name    => short_name,
        :search_params => search_params,
      }
    end

    # # プレイヤー情報の仕様に合わせて xmode を含めていない
    # # でも友対では棋力は上がらないので含めた方がいいかもしれない
    # def search_params
    #   {
    #     "開始モード" => imode_info&.name,
    #     "持ち時間"   => rule&.name,
    #   }.compact,
    # end

    def imode_info
      ImodeInfo.fetch_if(imode_key)
    end

    def xmode_info
      XmodeInfo.fetch_if(xmode_key)
    end

    def rule
      RuleInfo.fetch_if(rule_key)
    end
  end
end
