import { Location   } from "shogi-player/components/models/location.js"
import { SfenFliper } from 'shogi-player/components/models/sfen_fliper.js'

export const app_article = {
  methods: {
    // 盤上の駒の左右反転
    sfen_transform(sfen) {
      if (this.soldier_hflip_info.key === "flip_on") {
        sfen = SfenFliper.sfen_flip_h_from_sfen(sfen)
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
