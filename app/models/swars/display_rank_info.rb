module Swars
  class DisplayRankInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :display_rank_ten_min,   name: "10分",       short_name: "10分", search_params: { "開始モード" => "通常", "持ち時間" => "10分", }, },
      { key: :display_rank_three_min, name: "3分",        short_name: "3分",  search_params: { "開始モード" => "通常", "持ち時間" => "3分",  }, },
      { key: :display_rank_ten_sec,   name: "10秒",       short_name: "10秒", search_params: { "開始モード" => "通常", "持ち時間" => "10秒", }, },
      { key: :display_rank_sprint,    name: "スプリント", short_name: "ス",   search_params: { "開始モード" => "スプリント",                 }, },
    ]

    def display_rank_item
      {
        :key           => key,
        :short_name    => short_name,
        :search_params => search_params,
      }
    end
  end
end
