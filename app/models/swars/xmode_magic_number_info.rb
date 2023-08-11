module Swars
  class XmodeMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", xmode_key: "野良", },
      { key: "magic_number:1", xmode_key: "友達", },
      { key: "magic_number:2", xmode_key: "指導", },

      # 4 が来る場合もあるらしいが条件がわからないためスキップさせることにする
      # >> |----------------------------------------|
      # >> | H_Kirara-LearningBot01-20230807_213854 |
      # >> | H_Kirara-LearningBot02-20230807_213814 |
      # >> | H_Kirara-LearningBot04-20230807_213304 |
      # >> | H_Kirara-LearningBot03-20230807_213219 |
      # >> |----------------------------------------|
      # { key: "magic_number:4", xmode_key: "謎BOT", },
    ]

    class << self
      def fetch_by_magic_number(number)
        fetch("magic_number:#{number}")
      end

      def lookup_by_magic_number(number)
        lookup("magic_number:#{number}")
      end
    end

    def xmode_info
      XmodeInfo.fetch(xmode_key)
    end
  end
end
