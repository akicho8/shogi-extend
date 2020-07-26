# -*- compile-command: "rails r 'Actb::Lineage.setup; tp Actb::Lineage'" -*-

module Actb
  class LineageInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "詰将棋",               type: "is-primary", },
      { key: "詰将棋(玉方持駒限定)", type: "is-primary", },
      { key: "実戦詰め筋",           type: "is-primary", },
      { key: "手筋",                 type: "is-primary", },
      { key: "必死",                 type: "is-primary", },
      { key: "必死逃れ",             type: "is-primary", },
      { key: "定跡",                 type: "is-primary", },
      { key: "秘密",                 type: "is-danger",  },
    ]
  end
end
