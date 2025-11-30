// |------------------------------------+----------------------------------------------------|
// | methods                            | desc                                               |
// |------------------------------------+----------------------------------------------------|
// | user_selected_avatar_safe_set(str) | str が絵文字なら user_selected_avatar を更新する   |
// | user_selected_avatar_clear()       | user_selected_avatar を空にす                      |
// | pentagon_to_avatar_finally_on      | 有効になっていると CSS が反応する                  |
// | pentagon_to_avatar_css_vars        | ☗☖をアバターに置き換えるためのCSS変数を返す      |
// | name_to_avatar_record(name)        | name から絵文字のURL変換する (画像またはsvgを指す) |
// | avatar_char_to_avatar_record(str)  | avatar_char から絵文字情報に変換する               |
// |------------------------------------+----------------------------------------------------|

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { parse as TwitterEmojiParser } from "@twemoji/parser"

import { AvatarSupport } from "./avatar_support.js"
import { avatar_input_modal } from "./avatar_input_modal.js"
import { mod_avatar_history } from "./mod_avatar_history.js"
import { PentagonAppearanceInfo } from "./pentagon_appearance_info.js"

import AvatarInputModal from "./AvatarInputModal.vue"

export const mod_avatar = {
  mixins: [
    avatar_input_modal,
    mod_avatar_history,
  ],
  methods: {
    // 文字列に絵文字があればそれを自分のアバターに設定する
    user_selected_avatar_safe_set(str) {
      const record = AvatarSupport.record_find(str)
      if (record) {
        this.user_selected_avatar_update_and_sync(record.text)
        return true
      }
    },

    // アバター未選択の状態にする
    user_selected_avatar_clear() {
      this.user_selected_avatar_update_and_sync("")
    },

    // str をアバターとして設定する
    user_selected_avatar_update_and_sync(str) {
      GX.assert_kind_of_string(str)
      GX.assert(AvatarSupport.strict_chars_count(str) <= 1, "AvatarSupport.strict_chars_count(str) <= 1")
      this.user_selected_avatar = str
      this.avatar_history_update()
      this.member_bc_restart()  // みんなに配る
    },

    //////////////////////////////////////////////////////////////////////////////// private

    // name から絵文字のURL変換する (画像またはsvgを指す)
    name_to_avatar_record(name) {
      let hv = null
      hv ??= this.__name_to_user_selected_avatar(name)
      hv ??= this.__name_to_selfie(name)
      hv ??= this.__name_to_animal(name)
      return hv
    },

    // name からプロフィール画像に変換する
    __name_to_user_selected_avatar(name) {
      const member_info = this.room_user_names_hash[name]
      if (member_info) {
        const v = member_info.user_selected_avatar
        if (v) {
          return this.avatar_char_to_avatar_record(v)
        }
      }
    },

    // name からプロフィール画像に変換する
    __name_to_selfie(name) {
      const member_info = this.room_user_names_hash[name]
      if (member_info) {
        const v = member_info.from_avatar_path
        if (v) {
          return {
            url: v,
            background_size: "cover",
            border_radius: "3px",
          }
        }
      }
    },

    // name から絵文字画像に変換する
    __name_to_animal(name) {
      const avatar_char = AvatarSupport.char_from_str(name)
      return this.avatar_char_to_avatar_record(avatar_char)
    },

    // avatar_char から絵文字情報に変換する
    avatar_char_to_avatar_record(str) {
      GX.assert_kind_of_string(str)
      const record = AvatarSupport.record_find(str)
      if (record) {
        return {
          url: record.url,
          background_size: "contain",
          border_radius: "unset",
          __emoji__: record.text, // デバッグ用
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    __pentagon_to_avatar_css_vars_by_location(location) {
      const acc = {}
      const name = this.location_to_user_name(location)
      if (name != null) {
        const record = this.name_to_avatar_record(name)
        acc[`--sb_${location.key}_avatar_background_image`] = `url(${record.url})`
        acc[`--sb_${location.key}_avatar_background_size`]  = record.background_size
        acc[`--sb_${location.key}_avatar_border_radius`]    = record.border_radius
      }
      return acc
    },
  },
  computed: {
    AvatarSupport() { return AvatarSupport },

    PentagonAppearanceInfo()   { return PentagonAppearanceInfo                                          },
    pentagon_appearance_info() { return this.PentagonAppearanceInfo.fetch(this.pentagon_appearance_key) },

    // ☗☖をアバターに置き換えることが可能か？
    // ・順番設定している
    // ・対局者が1人以上いること (this.vs_member_infos.length >= 1) ← やめ
    // これをフラグにして class に定義することで css 側で記述できる
    pentagon_to_avatar_finally_on() {
      return this.pentagon_appearance_info.key === "pentagon_appearance_as_avatar" && this.order_enable_p
    },

    // ☗☖をアバターに置き換えるためのCSS変数たちを返す
    // 検索用: sb_avatar_url_black / sb_avatar_url_white
    pentagon_to_avatar_css_vars() {
      let acc = {}
      this.Location.values.forEach(location => {
        acc = {...acc, ...this.__pentagon_to_avatar_css_vars_by_location(location)}
      })
      return acc
    },

    // すべてのメンバーが選択したアバターを返す
    all_user_selected_avatars() {
      return this.member_infos.map(e => e.user_selected_avatar).join(",")
    },
  },
}
