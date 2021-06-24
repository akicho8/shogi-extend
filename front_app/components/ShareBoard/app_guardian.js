import _ from "lodash"
import dayjs from "dayjs"
import { parse as TwitterEmojiParser } from 'twemoji-parser'

export const app_guardian = {
  methods: {
    // 指定番号の守護獣URL取得
    guardian_url_from_index(index) {
      return this.ary_cycle_at(this.guardian_list, index)
    },

    // 文字列から守護獣URLに変換
    guardian_url_from_str(str) {
      const guardian = this.guardian_from_str(str)
      const entities = TwitterEmojiParser(guardian)
      this.__assert__(this.present_p(entities), "this.present_p(entities)")
      return entities[0].url
    },

    // 文字列から守護獣に変換
    guardian_from_str(str) {
      // if (this.development_p) {
      //   return _.sample(this.guardian_list)
      // }
      const pepper = dayjs().format("YYYY-MM")
      const hash_number = this.hash_number_from_str([pepper, str].join("-"))
      return this.ary_cycle_at(this.guardian_list, hash_number)
    },
  },
  computed: {
    // 簡単に採取できる便利サイト
    // https://jp.piliapp.com/twitter-symbols/
    // 💩
    guardian_list() {
      return [
        ..."🍉🥕🍆🥦🥝🍩",
        ..."💀💩🧠🫀",
        ..."🔞",
        ..."🐶🐱🐹🐻🐼️🐯🦁🐮🐷🐸🐵🦍🦧🐔🐧🐦🐤🐣🐥🐺🦊🦝🐗🐴🦓🦒🦌🦘🦥🦫🦄🐝🐛🦋🐌🪲🐞🐜🦗🪳🕷🦂🦟🪰🐢🐍🦎🐙🦑🦞🦀🐠🐟🐡🐬🦈🐳🐊🐆🐅🐄🦬🦣🦇🐓🦃🦅🦆🦢🦉🦩🦜🦤🦔🐲",
      ]
    },
  },
}
