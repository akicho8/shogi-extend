import { GX } from "@/components/models/gx.js"

export const mod_think_mark_restore = {
  methods: {
    // 現在の状態から think_mark_list_str を作る
    // デバッグ用
    sp_think_mark_list_serialize_display() {
      const mut_think_mark_list = this.sp_call(e => e.mut_think_mark_list)
      const think_mark_list_str = mut_think_mark_list.to_a.map(e => [
        e.mark_pos_key,
        e.mark_user_name,
        e.mark_color_index,
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
      return GX.ary_each_slice_to_a(ary, 3).map(([mark_pos_key, mark_user_name, mark_color_index]) => {
        return {
          mark_pos_key: mark_pos_key,
          mark_user_name: mark_user_name,
          mark_color_index: mark_color_index,
        }
      })
    },
  },
}
