import _ from "lodash"
import { Location   } from "shogi-player/components/models/location.js"
import { AvatarKingInfo } from "@/components/models/avatar_king_info.js"

const AVATAR_AS_KING   = true // アバターを玉にする(優先度高)
const GUARDIAN_AS_KING = true // 守護獣を玉にする(優先度低)

export const app_avatar = {
  data() {
    return {
      avatar_king_key: null, // アバター表示
    }
  },
  methods: {
    // private
    one_side_piece_replace_style(e) {
      return `
        .ShareBoardApp
          .CustomShogiPlayer
            .PieceTexture
              .PieceTextureSelf.piece_K.location_${e.location_key} {
                background-image: url(${e.from_avatar_path});
                border-radius: ${e.border_radius}%;
                background-size: cover;
              }`
    },
  },
  created() {
    this.DEFAULT_VARS = {
      ...this.DEFAULT_VARS,
      avatar_king_key: this.development_p ? "is_avatar_king_on" : "is_avatar_king_on",
    }
  },
  computed: {
    AvatarKingInfo()   { return AvatarKingInfo                                     },
    avatar_king_info() { return this.AvatarKingInfo.fetch_if(this.avatar_king_key) },

    component_raw_css() {
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
    //     black: { location_key: "black", from_avatar_path: "path/to/black_side_alice.png", border_radius: 100, },
    //     white: { location_key: "white", from_avatar_path: "path/to/white_side_bob.png"  , border_radius: 0,   },
    //   }
    //
    avatars_hash() {
      const hash = {}
      if (this.order_func_p && this.ordered_members_present_p) {
        for (const e of this.member_infos) {
          const info = this.base.user_names_hash[e.from_user_name]
          if (info) { // 対局メンバーなら
            const location = this.current_sfen_info.location_by_offset(info.order_index)
            if (hash[location.key] == null) {
              let value = null

              if (AVATAR_AS_KING) {
                if (value == null) {
                  if (e.from_avatar_path) {
                    value = {
                      from_avatar_path: e.from_avatar_path,
                      border_radius: 100,
                    }
                  }
                }
              }

              if (GUARDIAN_AS_KING) {
                if (value == null) {
                  value = {
                    from_avatar_path: this.guardian_url_from_str(e.from_user_name),
                    border_radius: 0,
                  }
                }
              }

              if (value) {
                hash[location.key] = { location_key: location.key, ...value }
                if (hash[location.flip.key]) {
                  break
                }
              }
            }
          }
        }
        return hash
      }
    },
  },
}
