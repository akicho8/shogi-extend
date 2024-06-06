# 将棋ウォーズのダメ設計が漏れ出ないように隠蔽する

module Swars
  class PresetMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", strict_preset_key: "平手",     },
      { key: "magic_number:1", strict_preset_key: "香落ち",   },
      { key: "magic_number:2", strict_preset_key: "角落ち",   },
      { key: "magic_number:3", strict_preset_key: "飛車落ち", },
      { key: "magic_number:4", strict_preset_key: "飛香落ち", },
      { key: "magic_number:5", strict_preset_key: "二枚落ち", },
      { key: "magic_number:6", strict_preset_key: "四枚落ち", },
      { key: "magic_number:7", strict_preset_key: "六枚落ち", },
      { key: "magic_number:8", strict_preset_key: "八枚落ち", },
      { key: "magic_number:9", strict_preset_key: "十枚落ち", },
    ]

    class << self
      def fetch_by_magic_number(number)
        fetch("magic_number:#{number}")
      end
    end

    def preset_info
      PresetInfo.fetch(strict_preset_key)
    end
  end
end
