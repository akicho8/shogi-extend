class WdayInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :sunday,    name: "日", category: "週末", },
    { key: :monday,    name: "月", category: "平日", },
    { key: :tuesday,   name: "火", category: "平日", },
    { key: :wednesday, name: "水", category: "平日", },
    { key: :thursday,  name: "木", category: "平日", },
    { key: :friday,    name: "金", category: "平日", },
    { key: :saturday,  name: "土", category: "週末", },
  ]

  class << self
    def fetch_by_dayofweek(index)
      fetch(index.pred)
    end
  end

  def dayofweek
    code.next
  end
end
