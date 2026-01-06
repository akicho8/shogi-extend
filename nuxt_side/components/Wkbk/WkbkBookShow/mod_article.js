import { Location   } from "shogi-player/components/models/location.js"
import { SfenTransformer } from 'shogi-player/components/models/sfen_transformer.js'

export const mod_article = {
  methods: {
    // 盤上の駒の左右反転
    sfen_flop(sfen) {
      if (this.soldier_flop_info.key === "flop_on") {
        sfen = SfenTransformer.flop(sfen)
      }
      return sfen
    },
  },

  computed: {
    // 視点
    current_viewpoint() {
      if (this.current_exist_p) {
        const on = this.viewpoint_flip_info.key === "flip_on"
        return Location.fetch(this.current_article.viewpoint).flip_if(on).key
      }
    },

    // 右側の答えを表示するか？
    answer_column_show() {
      return this.current_article.moves_answers.length >= 1
    },
  },
}
