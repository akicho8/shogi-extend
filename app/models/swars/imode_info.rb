module Swars
  class ImodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :normal, name: "通常",       },
      { key: :sprint, name: "スプリント", },
    ]

    prepend AliasMod

    def long_name
      "#{name}対局"
    end

    def sw_side_key
      key
    end

    def secondary_key
      name
    end
  end
end
