# 将棋ウォーズのダメ設計が漏れないように隠蔽する

module Swars
  class PresetMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", real_key: "平手",     },
      { key: "magic_number:1", real_key: "香落ち",   },
      { key: "magic_number:2", real_key: "角落ち",   },
      { key: "magic_number:3", real_key: "飛車落ち", },
      { key: "magic_number:4", real_key: "飛香落ち", },
      { key: "magic_number:5", real_key: "二枚落ち", },
      { key: "magic_number:6", real_key: "四枚落ち", },
      { key: "magic_number:7", real_key: "六枚落ち", },
      { key: "magic_number:8", real_key: "八枚落ち", },
      { key: "magic_number:9", real_key: "十枚落ち", },
    ]

    class << self
      def by_magic_number(number)
        fetch("magic_number:#{number}")
      end
    end

    def preset_info
      PresetInfo.fetch(real_key)
    end
  end
end
