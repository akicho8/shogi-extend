import { Location   } from "shogi-player/components/models/location.js"
import { SfenParser } from 'shogi-player/components/models/sfen_parser.js'

export const app_article = {
  methods: {
    // 盤上の駒の左右反転
    sfen_flop(sfen) {
      if (this.soldier_flop_info.key === "flip_on") {
        sfen = SfenParser.sfen_flop(sfen)
      }
      return sfen
    },
  },

  computed: {
    // 視点
    current_sp_viewpoint() {
      if (this.current_exist_p) {
        const on = this.viewpoint_flip_info.key === "flip_on"
        return Location.fetch(this.current_article.viewpoint).flip_if(on).key
      }
    },
  },
}
