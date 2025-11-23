import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class BoardPresetInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // sfen の b w  で最初の手番が決まる
      { key: "平手",           handicap_level:    54, description: "互角 (1段級差は下位者を☗とする)", sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1", },
      { key: "香落ち",         handicap_level:   107, description: "2段級差",                         sfen: "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", },
      // { key: "右香落ち",    handicap_level:   107, description: "あまり用いない",                  sfen: "position sfen 1nsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1", },
      { key: "角落ち",         handicap_level:   773, description: "3段級差",                         sfen: "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   },
      { key: "飛車落ち",       handicap_level:   810, description: "4段級差",                         sfen: "position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   },
      { key: "飛香落ち",       handicap_level:   927, description: "5段級差",                         sfen: "position sfen lnsgkgsn1/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",   },
      { key: "新宿の殺し屋",   handicap_level:  1023, description: "5.5段級差",                       sfen: "position sfen 4k4/1r5r1/ppppppppp/9/9/9/PPPPPPPPP/9/LNSGKGSNL w - 1",           }, // 小池重明が用いたと噂の手合割
      { key: "二枚落ち",       handicap_level:  1876, description: "6〜7段級差",                      sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     },
      // { key: "三枚落ち",    handicap_level:  2093, description: "8段級差",                         sfen: "position sfen lnsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     },
      { key: "四枚落ち",       handicap_level:  2285, description: "8〜9段級差",                      sfen: "position sfen 1nsgkgsn1/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",     },
      { key: "六枚落ち",       handicap_level:  2803, description: "10段級差",                        sfen: "position sfen 2sgkgs2/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",       },
      { key: "トンボ",         handicap_level:  3815, description: "11〜12段級差",                    sfen: "position sfen 4k4/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",       },
      { key: "八枚落ち",       handicap_level:  4658, description: "13段級差",                        sfen: "position sfen 3gkg3/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",         },
      { key: "二枚持ち",       handicap_level:  4898, description: "14段級差",                        sfen: "position sfen lnsgkgsnl/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w RB 1",    },
      { key: "十枚落ち",       handicap_level:  5783, description: "15段級差",                        sfen: "position sfen 4k4/9/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",           },
      { key: "十九枚落ち",     handicap_level: 99999, description: "100段級差",                       sfen: "position sfen 4k4/9/9/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1",                   },
      // --------------------------------------------------------------------------------
      { key: "飛vs角",         handicap_level:    21, description: "互角",                            sfen: "position sfen lnsgkgsnl/1b5b1/ppppppppp/9/9/9/PPPPPPPPP/1R5R1/LNSGKGSNL b - 1", },
      { key: "青空将棋",       handicap_level:  1428, description: "先手優勢",                        sfen: "position sfen lnsgkgsnl/1r5b1/9/9/9/9/9/1B5R1/LNSGKGSNL b - 1",                 },
      // --------------------------------------------------------------------------------
      { key: "穴熊対決",       handicap_level:    92, description: "ほぼ互角",                        sfen: "position sfen lns3gnk/1r3bgsl/ppppppppp/9/9/9/PPPPPPPPP/LSGB3R1/KNG3SNL b - 1", },
      { key: "矢倉対決",       handicap_level:    71, description: "ほぼ互角",                        sfen: "position sfen lns4nl/1r3bgk1/pppppgspp/5pp2/9/2PP5/PPSGPPPPP/1KGB3R1/LN4SNL b - 1", },
      { key: "石田流対決",     handicap_level:   143, description: "先手有利",                        sfen: "position sfen ln6l/1skgg4/1pppp1npb/p3spr1p/2P3p2/P1RPS3P/BPN1PPPP1/4GGKS1/L6NL b - 1", },
    ]
  }
}
