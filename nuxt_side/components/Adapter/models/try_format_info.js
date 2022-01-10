const FID_F03FD8D20A7EDED3B334EC8559F54BC5 = `
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)   (00:00/00:00:00)
   2 ３四歩(33)   (00:00/00:00:00)
`

const FID_08B710B6ADB4F165A1D7BEF2B7E7E09F = `
手合割：平手
-------手数-指手-消費時間---------
   1 ７六歩(77)   (00:00/00:00:00)
   2 ３四歩(33)   (00:00/00:00:00)
`

const FID_9AA77385759135C205DF617DF911104B = `
1 ７六歩(77)   (00:00/00:00:00)
2 ３四歩(33)   (00:00/00:00:00)
`

const FID_244CDFFF17E5E5B20FC39A4AD2EED862 = `
７六歩(77)
３四歩(33)
`

const FID_DCF9CF991E3E5606077CCCF9B14DF241 = `
７六歩
３四歩
`

const FID_8B5C41627CADD82350B5C778AE87981F = `
V2.2
PI
+
+7776FU
-3334FU
%TORYO
`
const FID_8B5C41627CADD82350B5C778AE87982F = `
+7776FU
-3334FU
`

const FID_1DF6E1EEE1425D098656807853E63126 = `V2.2,PI,+,+7776FU,-3334FU,%TORYO`

const FID_D10768CD364F5A0C433D48F3ABEB4A07 = `
手合割：角落ち
△８四歩 ▲７六歩
`

const FID_4E2D0CCEDDD3AF9ADE989AD21F76E266 = `
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

const FID_29F7F1E2AEACD6AB83035EFEDAA7977F = `
手合割：平手
棋戦：R対局室(15分)
手数----指手---------消費時間--
 1 ７六歩(77)   ( 0:02/00:00:02)
 2 ３四歩(33)   ( 0:02/00:00:02)
 3 反則勝ち
`

const FID_29F7F1E2AEACD6AB83035EFEDAA7978F = `
V2.2
P1-OU *  *  *  *  *  *  *  *
P2 *  * +TO *  *  *  *  *  *
P3+TO+TO+TO *  *  *  *  *  *
P4 *  *  *  *  *  *  *  *  *
P5 *  *  * -KA * +FU *  *  *
P6 *  *  * -UM+FU * +FU+FU+FU
P7 *  *  *  *  * -TO *  *  *
P8 *  *  *  *  * +KI+GI-HI+OU
P9 *  * -HI *  * +KI *  * +KY
P+00KI
P+00KI
P-00GI00GI
P-00KE
+
+1828OU,T1
-4738TO,T1
%TORYO
`

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TryFormatInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        name: "KIF",
        items: [
          { name: "基本",                                                         success: true,  body: FID_F03FD8D20A7EDED3B334EC8559F54BC5,                                                                                                                                                                                                                                                                                                                     },
          { name: "セパレーターが変",                                             success: true,  body: FID_08B710B6ADB4F165A1D7BEF2B7E7E09F,                                                                                                                                                                                                                                                                                                                    },
          { name: "ヘッダもセパレータもない",                                     success: true,  body: FID_9AA77385759135C205DF617DF911104B,                                                                                                                                                                                                                                                                                                                    },
          { name: "手番も時間もない",                                             success: true,  body: FID_244CDFFF17E5E5B20FC39A4AD2EED862,                                                                                                                                                                                                                                                                                                                    },
          { name: "移動元もない",                                                 success: true,  body: FID_DCF9CF991E3E5606077CCCF9B14DF241,                                                                                                                                                                                                                                                                                                                    },
          { name: "手番じゃないのに投了できる将棋倶楽部24の棋譜(激指では読めない)", success: true,  body: FID_29F7F1E2AEACD6AB83035EFEDAA7977F,                                                                                                                                                                                                                                                                                                                     },
        ],
      },
      {
        name: "KI2",
        items: [
          { name: "基本",                     success: true,  body: "▲76歩 △34歩",                                                                        },
          { name: "先後の記号がUTF-8依存",    success: true,  body: "☗76歩 ☖34歩",                                                                          },
          { name: "そもそも先後の記号がない", success: true,  body: "76歩 34歩",                                                                            },
          { name: "スペース区切りもない",     success: true,  body: "76歩34歩",                                                                             },
          { name: "全部漢字",                 success: true,  body: "七六歩 三四歩",                                                                        },
          { name: "駒落ち",                   success: true,  body: "手合割：角落ち\n△８四歩 ▲７六歩",                                                    },
          { name: "自由すぎる",               success: true,  body: "棋譜を送ります\n\n６8銀、三4歩(33)・☗七九角、8四歩五六歩△85歩78金\n\niPhoneから送信", },
          { name: "手番違い",                 success: false, body: "34歩",                                                                                 },
          { name: "移動元が曖昧",             success: false, body: "58金",                                                                                 },
        ],
      },
      {
        name: "CSA",
        items: [
          { name: "基本形",         success: true,  body: FID_8B5C41627CADD82350B5C778AE87981F, },
          { name: "1行",            success: true,  body: FID_1DF6E1EEE1425D098656807853E63126, },
          { name: "指し手しかない", success: true,  body: FID_8B5C41627CADD82350B5C778AE87982F, },
          { name: "初手55飛打",     success: false, body: `+0055RY`,                            },
          { name: "詰将棋",         success: true,  body: FID_29F7F1E2AEACD6AB83035EFEDAA7978F, },
        ],
      },
      {
        name: "SFEN",
        items: [
          { name: "基本形(だが position を SFEN に含むかどうかの解釈が曖昧)", success: true,  body: "position sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                            },
          { name: "省略形を含む",                                             success: true,  body: "position startpos moves 7g7f 3c3d 2g2f 8c8d",                                                                                                                                                                                                                                                                                    },
          { name: "position が欠けている",                                    success: true,  body: "sfen 7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                                     },
          { name: "sfen まで欠けている",                                      success: true,  body: "7nl/7k1/9/7pp/6N2/9/9/9/9 b GS2r2b3g3s2n3l16p 1 moves S*2c 2b1c 2c1b+",                                                                                                                                                                                                                                                          },
        ],
      },
      {
        name: "BOD",
        items: [
          { name: "基本", success: true,  body: FID_4E2D0CCEDDD3AF9ADE989AD21F76E266, },
        ],
      },

      {
        name: "KENTO",
        items: [
          { name: "KENTOのブラウザURL",   success: true,  body: "https://www.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6",                                                                         },
          { name: "KENTOの共有URL",       success: true,  body: "https://share.kento-shogi.com/?branch=N%2A7e.7d7e.B%2A7d.8c9c.G%2A9b.9a9b.7d9b%2B.9c9b.6c7b.R%2A8b.G%2A8c.9b9a.7b8b.7c8b.R%2A9b&branchFrom=0&initpos=ln7%2F2g6%2F1ks%2BR5%2Fpppp5%2F9%2F9%2F%2Bp%2Bp%2Bp6%2F2%2Bp6%2FK1%2Bp6%20b%20NGB9p3l2n3s2gbr%201#6",                                                                         },
        ],
      },

      {
        name: "将棋DB2",
        items: [
          { name: "将棋DB2の対局URL",     success: true,  body: "https://shogidb2.com/games/0e0f7f6518bca14e5b784015963d5f38795c86a7", },
          { name: "将棋DB2の読み筋",      success: true,  body: "https://shogidb2.com/board?sfen=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F2P6%2FPP1PPPPPP%2F1B5R1%2FLNSGKGSNL%20w%20-%202&moves=-3334FU%2B2726FU-8384FU%2B2625FU-8485FU%2B5958OU-4132KI%2B6978KI-8586FU%2B8786FU-8286HI%2B2524FU-2324FU%2B2824HI-8684HI%2B0087FU-0023FU%2B2428HI-2233KA%2B5868OU-7172GI%2B9796FU-3142GI%2B8833UM", },
        ],
      },

      {
        name: "lishogi",
        items: [
          { name: "対局",                                                     success: true,  body: "https://lishogi.org/151jxej8",       },
          { name: "対局(先手側)",                                             success: true,  body: "https://lishogi.org/151jxej8/sente", },
          { name: "対局(後手側)",                                             success: true,  body: "https://lishogi.org/151jxej8/gote",  },
          { name: "対局キーとプレイヤーを表わすキーが連結している場合がある", success: true,  body: "https://lishogi.org/151jxej8juO1",   },
          { name: "KIF export url",                                           success: true,  body: "https://lishogi.org/game/export/151jxej8?csa=0&clocks=0", },
          { name: "5五将棋のCSAエクスポートは盤の初期配置が違うため失敗",     success: false, body: "https://lishogi.org/wbvpq4cR",       },
        ],
      },

      {
        name: "将棋ウォーズ対局",
        items: [
          { name: "将棋ウォーズ対局",     success: true,  body: "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1",                                                                                                                                                                                                                                                         },
          { name: "将棋ウォーズ対局(旧)", success: true,  body: "https://kif-pona.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900?tw=1",                                                                                                                                                                                                                                                          },
        ],
      },

      {
        name: "共有将棋盤",
        items: [
          { name: "二歩", success: true,  body: "https://www.shogi-extend.com/share-board?body=position.sfen.4k4%2F9%2F4p4%2F9%2F9%2F9%2F4P4%2F9%2F4K4.b.P.1.moves.5g5f.5c5d.P%2a5e", },
        ],
      },

      {
        name: "将棋ウォーズ棋譜検索詳細",
        items: [
          { name: "ウォーズ棋譜検索詳細", success: true,  body: "https://www.shogi-extend.com/swars/battles/Kato_Hifumi-SiroChannel-20200927_180900/?viewpoint=white&turn=9", },
        ],
      },

      {
        name: "棋王戦",
        items: [
          { name: "公式サイト",                                                                  success: true,  body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html",                                                                                                                                                                                                                                                                     },
          { name: "KIFファイル(改行ではなく '\\n' という表示が含まれている。さらに Shift_JIS)",  success: true,  body: "http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif",                                                                                                                                                                                                                                                                      },
        ],
      },

      {
        name: "王将戦",
        items: [
          { name: "公式サイト",  success: true,  body: "https://mainichi.jp/oshosen-kifu/220109.html", },
        ],
      },

      {
        name: "ファイル",
        items: [
          { name: "UTF-8",      success: true,  body: "http://www.shogi-extend.com/example_utf_8.kif",     },
          { name: "Shift_JIS",  success: true,  body: "http://www.shogi-extend.com/example_shift_jis.kif", },
        ],
      },

      {
        name: "URLパラメータ",
        items: [
          { name: "kif",      success: true,  body: "http://example.com/?kif=76%E6%AD%A9"     },
          { name: "ki2",      success: true,  body: "http://example.com/?ki2=76%E6%AD%A9"     },
          { name: "csa",      success: true,  body: "http://example.com/?csa=76%E6%AD%A9"     },
          { name: "bod",      success: true,  body: "http://example.com/?bod=76%E6%AD%A9"     },
          { name: "kifu",     success: true,  body: "http://example.com/?kifu=76%E6%AD%A9"    },
          { name: "body",     success: true,  body: "http://example.com/?body=76%E6%AD%A9"    },
          { name: "text",     success: true,  body: "http://example.com/?text=76%E6%AD%A9"    },
          { name: "content",  success: true,  body: "http://example.com/?content=76%E6%AD%A9" },
          { name: "fragment", success: true,  body: "http://example.com/#76%E6%AD%A9"         },
        ],
      },

      {
        name: "その他",
        items: [
          { name: "戦法", success: true,  body: "極限早繰り銀",     },
          { name: "囲い", success: true,  body: "ダイヤモンド美濃", },
          { name: "手筋", success: true,  body: "割り打ちの銀",     },
          { name: "手合", success: true,  body: "四枚落ち",         },
        ],
      },
    ]
  }
}
