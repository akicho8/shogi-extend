# -*- compile-command: "rails r 'Actb::Lineage.setup; tp Actb::Lineage'" -*-

module Actb
  # リネーム方法
  # rails r 'Actb::Lineage.fetch("詰将棋(玉方持駒限定)").update!(key: "玉方持駒限定詰将棋")'
  class LineageInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "詰将棋",                   type: "is-primary", mate_validate_on: true,  piece_counts_check_on: true,  mochigomagentei: false, black_piece_zero_check_on: true,  },
      { key: "玉方持駒限定詰将棋", type: "is-primary", mate_validate_on: true,  piece_counts_check_on: false, mochigomagentei: true,  black_piece_zero_check_on: false, },
      { key: "実戦詰め筋",               type: "is-primary", mate_validate_on: true,  piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
      { key: "手筋",                     type: "is-primary", mate_validate_on: false, piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
      { key: "必死",                     type: "is-primary", mate_validate_on: false, piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
      { key: "必死逃れ",                 type: "is-primary", mate_validate_on: false, piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
      { key: "定跡",                     type: "is-primary", mate_validate_on: false, piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
      { key: "秘密",                     type: "is-danger",  mate_validate_on: false, piece_counts_check_on: false, mochigomagentei: false, black_piece_zero_check_on: false, },
    ]
  end
end
