module Swars
  class DirtyXmodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "__magic_code__0", xmode_key: "通常", },
      { key: "__magic_code__1", xmode_key: "友達", },
      { key: "__magic_code__2", xmode_key: "指導", },
    ]

    def xmode
      Xmode.fetch(xmode_key)
    end
  end
end
