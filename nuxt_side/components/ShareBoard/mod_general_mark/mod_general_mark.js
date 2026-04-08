import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"

const SS_MARK_COLOR_COUNT = 12    // shogi-player 側で用意している色数。同名の定数と合わせる。
const PEPPER_DATE_FORMAT  = "-"   // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意せよ。

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
        general_mark_pos_key: general_mark_pos_key,              // 位置 (必須)
        general_mark_group_name: this.user_name,                 // 名前
        general_mark_color_index: this.general_mark_color_index, // 色 (名前から自動的に決めている)
      }
    },
    // 現在の状態から general_mark_list_str を作る
    // デバッグ用
    sp_general_mark_list_serialize_display(ary) {
      const str = ary.to_a.map(e => [
        e.general_mark_pos_key,
        e.general_mark_group_name,
        e.general_mark_color_index,
      ].join(",")).join(",")
      console.log({str})
    },
  },
  computed: {
    // 引数から印の配列を作る
    // 動作確認やデモ用
    // カンマで区切って3つずつ取り出す
    // http://localhost:4000/share-board?general_mark_list_str=7_7,alice,0,7_6,bob,1
    sp_general_mark_list() {
      const ary = GX.str_split(this.general_mark_list_str ?? "", /,/)
      return GX.ary_each_slice_to_a(ary, 3).map(([general_mark_pos_key, general_mark_group_name, general_mark_color_index]) => {
        return {
          general_mark_pos_key: general_mark_pos_key,
          general_mark_group_name: general_mark_group_name,
          general_mark_color_index: general_mark_color_index,
        }
      })
    },

    // 現在の利用者の名前に対応する色番号を得る
    general_mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, this.user_name].join("-"))
      return GX.imodulo(hash_number, SS_MARK_COLOR_COUNT)
    },
  },
}
