const PEPPER_DATE_FORMAT = "-" // 守護獣が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"

export const mod_guardian = {
  methods: {
    // 指定番号の守護獣URL取得
    guardian_url_base_index(index) {
      return GX.ary_cycle_at(this.guardian_list, index)
    },

    // 文字列から守護獣に変換
    guardian_from_str(str) {
      // if (this.development_p) {
      //   return _.sample(this.guardian_list)
      // }
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, str].join("-"))
      return GX.ary_cycle_at(this.guardian_list, hash_number)
    },
  },
  computed: {
    // 簡単に採取できる便利サイト
    // https://jp.piliapp.com/twitter-symbols/
    // 💩
    guardian_list() {
      return [
        ..."🍉🥕🍆🥦🥝🍩",
        // ..."💀💩🧠🫀",
        ..."🔞",
        ..."🐶🐱🐹🐻🐼🐯🦁🐮🐷🐸🐵🦍🦧🐔🐦🐥🦊🐗🐴🦓🦌🦄🐬🦅🦆🦉🦩🦜🦔🐲",
        // ..."🐞",
        // ..."🐶🐱🐹🐻🐼️🐯🦁🐮🐷🐸🐵🦍🦧🐔🐧🐦🐤🐣🐥🐺🦊🦝🐗🐴🦓🦒🦌🦘🦥🦫🦄🐝🐛🦋🐌🪲🐞🐜🦗🪳🕷🦂🦟🪰🐢🐍🦎🐙🦑🦞🦀🐠🐟🐡🐬🦈🐳🐊🐆🐅🐄🦬🦣🦇🐓🦃🦅🦆🦢🦉🦩🦜🦤🦔🐲",
      ]
    },
  },
}
