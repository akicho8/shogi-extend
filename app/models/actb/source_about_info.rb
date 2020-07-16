module Actb
  class SourceAboutInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :ascertained, name: "作者判明", },
      { key: :unknown,     name: "作者不詳", },
    ]
  end
end
