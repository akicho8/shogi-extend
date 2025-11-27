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
      const pepper = dayjs().format(this.AppConfig.AVATAR_PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, name].join("-"))
      return GX.ary_cycle_at(this.AvatarChars, hash_number)
    },

    // name から絵文字のURL変換する (画像またはsvgを指す)
    name_to_avatar_url(name) {
      let url = null
      url ??= this.__ms_pentagon_name_to_profile_image_url(name)
      url ??= this.__ms_pentagon_name_to_svg_url(name)
      return url
    },

    //////////////////////////////////////////////////////////////////////////////// private

    // name からプロフィール画像
    __ms_pentagon_name_to_profile_image_url(name) {
      const member_info = this.room_user_names_hash[name]
      if (member_info && member_info.from_avatar_path) {
        return member_info.from_avatar_path
      }
    },

    // name から絵文字画像
    __ms_pentagon_name_to_svg_url(name) {
      const avatar = this.name_to_avatar_char(name)
      const elem = TwitterEmojiParser(avatar)[0]
      if (elem) {
        return elem.url
      }
    },

    // location 側の☗を url に置き換える
    __ms_pentagon_css_of(location, url) {
      return `.SbApp .SbSp .is_${location.key} .MembershipLocationMarkTexture { background-image: url(${url}) }`
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    AvatarChars() { return AvatarChars },

    // ☗☖をアバターに置き換えるためのCSSを返す
    ms_pentagon_replace_css() {
      return this.Location.values.map(location => {
        const name = this.location_to_user_name(location)
        if (name != null) {
          const url = this.name_to_avatar_url(name)
          return this.__ms_pentagon_css_of(location, url)
        }
      }).join(" ")
    },
  },
}
