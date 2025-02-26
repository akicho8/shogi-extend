module Swars
  class Xmode2MagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number:0", xmode2_key: :normal, },
      { key: "magic_number:1", xmode2_key: :sprint, },
    ]

    class << self
      def fetch_by_magic_number(number)
        fetch("magic_number:#{number}")
      end

      def lookup_by_magic_number(number)
        lookup("magic_number:#{number}")
      end
    end

    def xmode2_info
      Xmode2Info.fetch(xmode2_key)
    end
  end
end
