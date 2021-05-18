import MemoryRecord from "js-memory-record"

export class KomaochiPresetInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "平手",           sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", description: "", },
      { key: "香落ち",         sfen: "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", description: "", },
      { key: "右香落ち",       sfen: "position sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", description: "", },
      { key: "角落ち",         sfen: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "", },
      { key: "飛車落ち",       sfen: "position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "", },
      { key: "飛香落ち",       sfen: "position sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   description: "", },
      { key: "二枚落ち",       sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "", },
      { key: "先崎流二枚落ち", sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w RB 1",    description: "初心者に勝つ楽しみ知って欲しいと考えた先崎学九段推奨のルール", },
      { key: "三枚落ち",       sfen: "position sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "", },
      { key: "四枚落ち",       sfen: "position sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     description: "", },
      { key: "六枚落ち",       sfen: "position sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",       description: "", },
      { key: "八枚落ち",       sfen: "position sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",         description: "", },
      { key: "十枚落ち",       sfen: "position sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",           description: "", },
      { key: "十九枚落ち",     sfen: "position sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",                   description: "", },
      { key: "飛vs角",         sfen: "position sfen lnsgkgsnl/1b5b1/ppppppppp/9/9/9/PPPPPPPPP/1R5R1/LNSGKGSNL w - 1", description: "", },
    ]
  }
}
