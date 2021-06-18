import _ from "lodash"
import { Location   } from "shogi-player/components/models/location.js"

export const app_avatar = {
  methods: {
    // private
    one_side_piece_replace_style(e) {
      return `
        .ShareBoardApp
          .CustomShogiPlayer
            .PieceTexture
              .PieceTextureSelf.piece_K.location_${e.location_key} {
                background-image: url(${e.from_avatar_path});
                border-radius: 100%;
                background-size: cover;
              }`
    },
  },
  computed: {
    component_css() {
      let v = null
      v = _.map(this.avatars_hash, (e, key) => this.one_side_piece_replace_style(e))
      v = v.join(" ")
      v = v.replace(/\s+/g, " ")
      return v
    },

    // private

    // メンバーを走査して代表メンバーのアバターを取得する
    // 前の方にいる人ほど代表になる
    //
    // return:
    //   {
    //     black: { location_key: "black", from_avatar_path: "path/to/black_side_alice.png" },
    //     white: { location_key: "white", from_avatar_path: "path/to/white_side_bob.png"   },
    //   }
    //
    avatars_hash() {
      const hash = {}
      if (this.order_func_p && this.ordered_members_present_p) {
        for (const e of this.member_infos) {
          if (e.from_avatar_path) {
            const info = this.base.user_names_hash[e.from_user_name]
            if (info) {
              const location = this.current_sfen_info.location_by_offset(info.order_index)
              if (hash[location.key] == null) {
                hash[location.key] = { location_key: location.key, from_avatar_path: e.from_avatar_path }
                if (hash[location.flip.key]) {
                  break
                }
              }
            }
          }
        }
      }
      return hash
    },
  },
}
