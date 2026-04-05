import { GX } from "@/components/models/gx.js"

export const mod_think_mark_restore = {
  methods: {
    // 現在の状態から think_mark_list_str を作る
    // デバッグ用
    sp_think_mark_list_serialize_display() {
      const mut_think_mark_list = this.sp_call(e => e.mut_think_mark_list)
      const think_mark_list_str = mut_think_mark_list.to_a.map(e => [
        e.think_mark_pos_key,
        e.think_mark_user_name,
        e.think_mark_color_index,
      ].join(",")).join(",")
      console.log({think_mark_list_str})
    },
  },
  computed: {
    // 引数から印の配列を作る
    // 動作確認やデモ用
    // カンマで区切って3つずつ取り出す
    // http://localhost:4000/share-board?think_mark_list_str=7_7,alice,0,7_6,bob,1
    sp_think_mark_list() {
      const ary = GX.str_split(this.think_mark_list_str ?? "", /,/)
      return GX.ary_each_slice_to_a(ary, 3).map(([think_mark_pos_key, think_mark_user_name, think_mark_color_index]) => {
        return {
          think_mark_pos_key: think_mark_pos_key,
          think_mark_user_name: think_mark_user_name,
          think_mark_color_index: think_mark_color_index,
        }
      })
    },
  },
}
