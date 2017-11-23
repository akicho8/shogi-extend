class GameTypeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :ten_min,   name: "10分", swars_key: "",   },
    {key: :three_min, name: "3分",  swars_key: "sb", },
    {key: :ten_sec,   name: "10秒", swars_key: "s1", },
  ]

  class << self
    def lookup(v)
      super || invert_table[v]
    end

    private

    def invert_table
      @invert_table ||= inject({}) {|a, e| a.merge(e.swars_key => e) }
    end
  end
end

if $0 == __FILE__
  tp GameTypeInfo[""]
  # |------|
  # | 10分 |
  # |------|
end
