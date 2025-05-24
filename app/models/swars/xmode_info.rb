module Swars
  class XmodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "野良", alias_key: nil, sw_side_key: "normal",       },
      { key: "友達", alias_key: nil, sw_side_key: "friend",       },
      { key: "指導", alias_key: nil, sw_side_key: "coach",        },
      { key: "大会", alias_key: nil, sw_side_key: "closed_event", },
    ]

    prepend AliasMod

    def long_name
      "#{key}対局"
    end

    def secondary_key
      [alias_key, sw_side_key]
    end
  end
end
