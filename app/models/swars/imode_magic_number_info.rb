module Swars
  class ImodeMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", imode_key: :normal, },
      { key: "magic_number:1", imode_key: :sprint, },
    ]

    class << self
      def fetch_by_magic_number(number)
        fetch("magic_number:#{number}")
      end

      def lookup_by_magic_number(number)
        lookup("magic_number:#{number}")
      end
    end

    def imode_info
      ImodeInfo.fetch(imode_key)
    end
  end
end
