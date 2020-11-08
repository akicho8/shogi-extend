const FORMAT_TYPE1 = `
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)   (00:00/00:00:00)
   2 ３四歩(33)   (00:00/00:00:00)
`

const FORMAT_TYPE11 = `
手合割：平手
-------手数-指手-消費時間---------
   1 ７六歩(77)   (00:00/00:00:00)
   2 ３四歩(33)   (00:00/00:00:00)
`

const FORMAT_TYPE12 = `
1 ７六歩(77)   (00:00/00:00:00)
2 ３四歩(33)   (00:00/00:00:00)
`

const FORMAT_TYPE13 = `
７六歩(77)
３四歩(33)
`

const FORMAT_TYPE14 = `
７六歩
３四歩
`

const FORMAT_TYPE2 = `
V2.2
PI
+
+7776FU
-3334FU
%TORYO
`

const FORMAT_TYPE3 = `V2.2,PI,+,+7776FU,-3334FU,%TORYO`

const FORMAT_TYPE4 = `
手合割：角落ち
△８四歩 ▲７六歩
`

const FORMAT_TYPE5 = `
後手の持駒：飛二 角二 金二 銀四 桂四 香四 歩十八
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・v玉 ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
| ・ ・ ・ ・ 金 ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
先手の持駒：金
手数＝0 まで
`

const FORMAT_TYPE6 = `
手合割：平手
棋戦：R対局室(15分)
手数----指手---------消費時間--
 1 ７六歩(77)   ( 0:02/00:00:02)
 2 ３四歩(33)   ( 0:02/00:00:02)
 3 反則勝ち
`

import _ from "lodash"

import MemoryRecord from 'js-memory-record'

export class AdapterTestInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "普通の KIF 形式",                    success: true,  body: FORMAT_TYPE1,                                                                                                                                                                                                                                                                                                                     },
      { name: "セパレーターが変",                   success: true,  body: FORMAT_TYPE11,                                                                                                                                                                                                                                                                                                                    },
      { name: "ヘッダがない",                       success: true,  body: FORMAT_TYPE12,                                                                                                                                                                                                                                                                                                                    },
      { name: "手番も時間もない",                   success: true,  body: FORMAT_TYPE13,                                                                                                                                                                                                                                                                                                                    },
      { name: "移動元もない",                       success: true,  body: FORMAT_TYPE14,                                                                                                                                                                                                                                                                                                                    },
      { name: "綺麗な KI2 形式",                    success: true,  body: "▲76歩 △34歩",                                                                                                                                                                                                                                                                                                    },
      { name: "駒落ち KI2 形式",                    success: true,  body: FORMAT_TYPE4,                                                                                                                                                                                                                                                                                                                     },
      { name: "▲△がない",                         success: true,  body: "76歩 34歩",                                                                                                                                                                                                                                                                                                            },
      { name: "いろいろ自由",                       success: true,  body: "棋譜を送ります\n６8銀、三4歩(33)・☗七九角、8四歩五六歩△85歩78金\niPhoneから送信",                                                                                                                                                                                                                                                                },
      { name: "将棋クエストの CSA 形式",            success: true,  body: FORMAT_TYPE2,                                                                                                                                                                                                                                                                                                                     },
      { name: "CSA 形式(1行)",                      success: true,  body: FORMAT_TYPE3,                                                                                                                                                                                                                                                                                                                     },
      { name: "BOD 形式",                           success: true,  body: FORMAT_TYPE5,                                                                                                                                                                                                                                                                                                                     },
      { name: "激指では読めない将棋倶楽部24の棋譜", success: true,  body: FORMAT_TYPE6,                                                                                                                                                                                                                                                                                                                     },
      { name: "正しい SFEN 形式",                   success: true,  body: "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                            },
      { name: "省略形を含む SFEN 形式",             success: true,  body: "position startpos moves 7g7f 3c3d 2g2f 8c8d",                                                                                                                                                                                                                                                                                    },
      { name: "position が欠けている",              success: true,  body: "sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                                     },
      { name: "sfen まで欠けている",                success: true,  body: "7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                                          },
      { name: "戦法",                               success: true,  body: "極限早繰り銀",                                                                                                                                                                                                                                                                                                                           },
      { name: "囲い",                               success: true,  body: "ダイヤモンド美濃",                                                                                                                                                                                                                                                                                                                           },
      { name: "手筋",                               success: true,  body: "割り打ちの銀",                                                                                                                                                                                                                                                                                                                           },
      { name: "手合",                               success: true,  body: "四枚落ち",                                                                                                                                                                                                                                                                                                                           },
      { name: "KENTOの局面URL",                     success: true,  body: "https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6",                                                                         },
      { name: "将棋DB2の局面URL",                   success: true,  body: "https://shogidb2.com/games/018d3d1ee6594c34c677260002621417c8f75221#lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202",                                                                                                                                                                    },
      { name: "将棋DB2の読み筋URL",                 success: true,  body: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM", },
      { name: "将棋ウォーズの対局URL",              success: true,  body: "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1",                                                                                                                                                                                                                                                         },
      { name: "将棋ウォーズの旧対局URL",            success: true,  body: "https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1",                                                                                                                                                                                                                                                          },
      { name: "棋王戦サイトURL",                    success: true,  body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html",                                                                                                                                                                                                                                                                     },
      { name: "棋王戦KIFのURL",                     success: true,  body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif",                                                                                                                                                                                                                                                                      },
      { name: "CSA形式 初手93角打",                 success: false, body: "V2,P1 *,+0093KA,T1",                                                                                                                                                                                                                                                                                                             },
      { name: "KI2形式 初手34歩 (手番間違い？)",    success: false, body: "34歩",                                                                                                                                                                                                                                                                                                                           },
      { name: "KI2形式 初手58金 (移動元不明)",      success: false, body: "58金",                                                                                                                                                                                                                                                                                                                           },
    ]
  }

  get striped_body() {
    return _.trim(this.body)
  }
}
