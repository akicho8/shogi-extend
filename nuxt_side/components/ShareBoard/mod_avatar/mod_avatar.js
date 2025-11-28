// |-----------------------------+----------------------------------------------------|
// | methods                     | desc                                               |
// |-----------------------------+----------------------------------------------------|
// | name_to_avatar_char(name)   | name から絵文字1文字に変換する                     |
// | __name_to_avatar_attrs(name)  | name から絵文字のURL変換する (画像またはsvgを指す) |
// | pentagon_to_avatar_mode_on  | 有効になっていると CSS が反応する                  |
// | pentagon_to_avatar_css_vars | ☗☖をアバターに置き換えるためのCSS変数を返す      |
// |-----------------------------+----------------------------------------------------|

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { parse as TwitterEmojiParser } from "@twemoji/parser"
import TwemojiApi from "@twemoji/api"

import { AvatarChars } from "./avatar_chars.js"

export const mod_avatar = {
  methods: {
    // name から絵文字1文字に変換する
    // メモ化したくなるが絶対すな
    name_to_avatar_char(name) {
      // if (this.debug_mode_p) {
      //   return "🐷"
      // }
      const pepper = dayjs().format(this.AppConfig.avatar.pepper_date_format)
      const hash_number = GX.str_to_hash_number([pepper, name].join("-"))
      return GX.ary_cycle_at(this.AvatarChars, hash_number)
    },

    //////////////////////////////////////////////////////////////////////////////// private

    // name から絵文字のURL変換する (画像またはsvgを指す)
    __name_to_avatar_attrs(name) {
      let hv = null
      hv ??= this.__name_to_selfie(name)
      hv ??= this.__name_to_animal(name)
      return hv
    },

    // name からプロフィール画像
    __name_to_selfie(name) {
      const member_info = this.room_user_names_hash[name]
      if (member_info && member_info.from_avatar_path) {
        return {
          type: "is_avatar_selfie",
          url: member_info.from_avatar_path,
          background_size: "cover",
          border_radius: "3px",
        }
      }
    },

    // name から絵文字画像
    __name_to_animal(name) {
      const avatar = this.name_to_avatar_char(name)
      const elem = TwitterEmojiParser(avatar)[0]
      if (elem) {
        return {
          type: "is_avatar_animal",
          url: elem.url,
          background_size: "contain",
          border_radius: "unset",
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    __pentagon_to_avatar_css_vars_by_location(location) {
      const hv = {}
      const name = this.location_to_user_name(location)
      if (name != null) {
        const attrs = this.__name_to_avatar_attrs(name)
        hv[`--sb_${location.key}_avatar_background_image`] = `url(${attrs.url})`
        hv[`--sb_${location.key}_avatar_background_size`]  = attrs.background_size
        hv[`--sb_${location.key}_avatar_border_radius`]    = attrs.border_radius
      }
      return hv
    },
  },
  computed: {
    AvatarChars() { return AvatarChars },

    // ☗☖をアバターに置き換えることが可能か？
    // ・順番設定している
    // ・対局者が1人以上いること (this.vs_member_infos.length >= 1) ← やめ
    // これをフラグにして class に定義することで css 側で記述できる
    pentagon_to_avatar_mode_on() {
      return this.order_enable_p
    },

    // ☗☖をアバターに置き換えるためのCSS変数たちを返す
    // sb_avatar_url_black / sb_avatar_url_white
    pentagon_to_avatar_css_vars() {
      let hv = {}
      if (this.AppConfig.avatar.pentagon_replace_feature) {
        this.Location.values.forEach(location => {
          hv = {...hv, ...this.__pentagon_to_avatar_css_vars_by_location(location)}
        })
      }
      return hv
    },
  },
}
