// |---------------------------+----------------------------------------------------|
// | methods                   | desc                                               |
// |---------------------------+----------------------------------------------------|
// | name_to_avatar_char(name) | name から絵文字1文字に変換する                     |
// | name_to_avatar_url(name)  | name から絵文字のURL変換する (画像またはsvgを指す) |
// | ms_pentagon_replace_css   | ☗☖をアバターに置き換えるためのCSSを返す          |
// |---------------------------+----------------------------------------------------|

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

    // name から絵文字のURL変換する (画像またはsvgを指す)
    name_to_avatar_url(name) {
      let hv = null
      hv ??= this.__ms_pentagon_name_to_profile_image_url(name)
      hv ??= this.__ms_pentagon_name_to_svg_url(name)
      return hv
    },

    //////////////////////////////////////////////////////////////////////////////// private

    // name からプロフィール画像
    __ms_pentagon_name_to_profile_image_url(name) {
      const member_info = this.room_user_names_hash[name]
      if (member_info && member_info.from_avatar_path) {
        return { type: "is_avatar_selfie", url: member_info.from_avatar_path }
      }
    },

    // name から絵文字画像
    __ms_pentagon_name_to_svg_url(name) {
      const avatar = this.name_to_avatar_char(name)
      const elem = TwitterEmojiParser(avatar)[0]
      if (elem) {
        return { type: "is_avatar_animal", url: elem.url }
      }
    },

    // FIXME: ここの部分はあらかじめ sass で記述し、url の部分だけを変更する
    // 順番 ON のときだけ作動するようにする
    // location 側の☗を url に置き換える
    __ms_pentagon_css_of(location, attrs) {
      if (attrs.type == "is_avatar_selfie") {
        return `
               .SbApp .SbSp .is_${location.key} {
                 .MembershipLocationMark {
                   /* width: unset; */           /* 元は升目の同じ大きさなので縦幅だけを無効化し */
                   /* aspect-ratio: 1; */         /* 比率を1:1にすることで縦も自動的に横と同じになる */
                   .MembershipLocationMarkTexture {
                     background-image: url(${attrs.url});
                     width: 100%;            /* そのため内側は最大化すればよい */
                     height: 100%;
                     background-size: cover; /* cover で完全に生める。contain だと元画像が長方形の場合に隙間ができてしまう */
                     border-radius: 3px;
                   }
                 }
               }
               `
      }
      if (attrs.type == "is_avatar_animal") {
        return `
               .SbApp .SbSp .is_${location.key} {
                 .MembershipLocationMark {
                   .MembershipLocationMarkTexture {
                     background-image: url(${attrs.url});
                     width: 100%;
                     height: 100%;
                     background-size: contain; /* 必ず含める */
                   }
                 }
               }
               `
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    AvatarChars() { return AvatarChars },

    // ☗☖をアバターに置き換えるためのCSSを返す
    ms_pentagon_replace_css() {
      if (this.AppConfig.avatar.pentagon_replace_feature) {
        return this.Location.values.map(location => {
          const name = this.location_to_user_name(location)
          if (name != null) {
            const attrs = this.name_to_avatar_url(name)
            return this.__ms_pentagon_css_of(location, attrs)
          }
        }).join(" ")
      }
    },
  },
}
