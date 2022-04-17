module Swars
  class XmodeMagicNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "magic_number_is_0", xmode_key: "通常", },
      { key: "magic_number_is_1", xmode_key: "友達", },
      { key: "magic_number_is_2", xmode_key: "指導", },
    ]

    def xmode
      Xmode.fetch(xmode_key)
    end
  end
end
