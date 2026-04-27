import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"

const SP_GENERAL_MARK_PALETTE_COUNT = 9     // shogi-player 側で用意している色数。同名の定数と合わせる。
const PEPPER_DATE_FORMAT            = "-"   // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意せよ。

export const mod_general_mark = {
  methods: {
    general_mark_clear_all() {
      this.think_mark_clear_all()
      this.origin_mark_clear_all()
    },

    // コマンド発行のための引数を作る
    general_mark_attributes_create(general_mark_pos_key) {
      GX.assert_kind_of_string(general_mark_pos_key)
      GX.assert_kind_of_string(this.user_name)
      GX.assert_kind_of_integer(this.general_mark_color_index)

      return {
        gm_pos_key: general_mark_pos_key,              // 位置
        gm_user_name: this.user_name,                  // 名前
        gm_color_index: this.general_mark_color_index, // 色
      }
    },
  },
  computed: {
    // 現在の利用者の名前に対応する色番号を得る
    general_mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, this.user_name].join("-"))
      return GX.imodulo(hash_number, SP_GENERAL_MARK_PALETTE_COUNT)
    },
  },
}
