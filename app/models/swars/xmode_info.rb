module Swars
  class XmodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "通常", },
      { key: "友達", },
      { key: "指導", },
    ]

    def long_name
      "#{key}対局"
    end
  end
end
