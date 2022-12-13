module Swars
  class XmodeMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", xmode_key: "野良", },
      { key: "magic_number:1", xmode_key: "友達", },
      { key: "magic_number:2", xmode_key: "指導", },
    ]

    class << self
      def by_magic_number(number)
        fetch("magic_number:#{number}")
      end
    end

    def xmode_info
      XmodeInfo.fetch(xmode_key)
    end
  end
end
