// テスト環境で sfen_parser が読み込む方法がわからないので仕方なく分けている

import { SfenParser } from "shogi-player/components/models/sfen_parser.js"

export const SpUtils = {
  // sfen_parser.moves.length
  sfen_parse(sfen) {
    return SfenParser.parse(sfen)
  },

  kento_full_url({sfen, turn, viewpoint}) {
    this.__assert__(sfen, "sfen is blank")

    const info = SfenParser.parse(sfen)
    const url = new URL("https://www.kento-shogi.com")

    // initpos は position sfen と moves がない初期局面の sfen
    url.searchParams.set("initpos", info.init_sfen_strip)

    // 視点も対応してくれるかもしれないので入れとく
    url.searchParams.set("viewpoint", viewpoint)

    // moves は別のパラメータでスペースを . に置き換えている(KENTOの独自の工夫)
    const { moves } = info.attributes
    if (moves) {
      url.searchParams.set("moves", moves.replace(/\s+/g, "."))
    }

    // #n が手数
    url.hash = turn

    return url.toString()
  },
}
