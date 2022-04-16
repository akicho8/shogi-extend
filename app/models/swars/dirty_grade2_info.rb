module Swars
  class DirtyGrade2Info
    include ApplicationMemoryRecord
    memory_record [
      { key: "__magic_code__0", grade2_key: "通常", },
      { key: "__magic_code__1", grade2_key: "友達", },
      { key: "__magic_code__2", grade2_key: "指導", },
    ]

    def grade2
      Grade2.fetch(grade2_key)
    end
  end
end
