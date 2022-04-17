module Swars
  class PresetMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number_is_0", normalized_key: "平手",     __swars_key: "Hirate",   },
      { key: "magic_number_is_1", normalized_key: "香落ち",   __swars_key: "Kyo",      },
      { key: "magic_number_is_2", normalized_key: "角落ち",   __swars_key: "Kaku",     },
      { key: "magic_number_is_3", normalized_key: "飛車落ち", __swars_key: "Hisha",    },
      { key: "magic_number_is_4", normalized_key: "飛香落ち", __swars_key: "HishaKyo", },
      { key: "magic_number_is_5", normalized_key: "二枚落ち", __swars_key: "Two",      },
      { key: "magic_number_is_6", normalized_key: "四枚落ち", __swars_key: "Four",     },
      { key: "magic_number_is_7", normalized_key: "六枚落ち", __swars_key: "Six",      },
      { key: "magic_number_is_8", normalized_key: "八枚落ち", __swars_key: "Eight",    },
      { key: "magic_number_is_9", normalized_key: "十枚落ち", __swars_key: "Ten",      },
    ]

    def preset_info
      Bioshogi::PresetInfo.fetch(normalized_key)
    end
  end
end
