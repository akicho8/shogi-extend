class UseInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :basic,   name: "基本", },
    { key: :adapter, name: "即席", },
    { key: :share_board,  name: "リレー", },
    { key: :kiwi_lemon,  name: "動画生成", },
  ]
end
