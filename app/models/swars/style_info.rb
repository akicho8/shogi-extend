module Swars
  class StyleInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "王道",   segment: :majority, },
      { key: "準王道", segment: :majority, },
      { key: "準変態", segment: :minority, },
      { key: "変態",   segment: :minority, },
    ]
  end
end
