// テスト環境で sfen_parser が読み込む方法がわからないので仕方なく分けている

import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { KifuVo } from "@/components/models/kifu_vo.js"

export const SpUtil = {
  // sfen_parser.moves.length
  sfen_parse(sfen) {
    return SfenParser.parse(sfen)
  },

  kento_url(attributes) {
    return KifuVo.create(attributes).kento_url
  },

  query_to_turn(query, max) {
    if ("turn" in query) {
      const turn = query.turn
      if (turn.match(/\d/)) {
        let rv = null
        const n = Number(turn)
        if (n < 0) {
          rv = max + 1 + n
        } else {
          rv = n
        }
        return rv
      }
    }
  },
}
