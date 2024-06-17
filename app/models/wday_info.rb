class WdayInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :sunday,    name: "日", },
    { key: :monday,    name: "月", },
    { key: :tuesday,   name: "火", },
    { key: :wednesday, name: "水", },
    { key: :thursday,  name: "木", },
    { key: :friday,    name: "金", },
    { key: :saturday,  name: "土", },
  ]

  class << self
    def fetch_by_odbc_code(index)
      fetch(index.pred)
    end
  end

  def odbc_code
    code.next
  end
end
