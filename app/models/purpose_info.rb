class PurposeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :basic,   name: "基本", },
    { key: :adapter, name: "即席", },
  ]
end
