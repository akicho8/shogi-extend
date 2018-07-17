module Colosseum
  class LastActionInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "TORYO",        name: "投了",     },
      { key: "TIME_UP",      name: "時間切れ", },
      { key: "ILLEGAL_MOVE", name: "反則",     },
      { key: "TSUMI",        name: "詰み",     },
    ]

    def as_json(options = {})
      super(options.merge(methods: [:name]))
    end
  end
end
