import { GX } from "@/components/models/gx.js"

export const mod_origin_mark_restore = {
  methods: {
    // 現在の状態から origin_mark_list_str を作る
    // デバッグ用
    sp_origin_mark_list_serialize_display() {
      const mut_origin_mark_list = this.sp_call(e => e.mut_origin_mark_list)
      const origin_mark_list_str = mut_origin_mark_list.to_a.map(e => [
        e.origin_mark_pos_key,
        e.origin_mark_user_name,
        e.origin_mark_color_index,
      ].join(",")).join(",")
      console.log({origin_mark_list_str})
    },
  },
  computed: {
    // 引数から印の配列を作る
    // 動作確認やデモ用
    // カンマで区切って3つずつ取り出す
    // http://localhost:4000/share-board?origin_mark_list_str=7_7,alice,0,7_6,bob,1
    sp_origin_mark_list() {
      const ary = GX.str_split(this.origin_mark_list_str ?? "", /,/)
      return GX.ary_each_slice_to_a(ary, 3).map(([origin_mark_pos_key, origin_mark_user_name, origin_mark_color_index]) => {
        return {
          origin_mark_pos_key: origin_mark_pos_key,
          origin_mark_user_name: origin_mark_user_name,
          origin_mark_color_index: origin_mark_color_index,
        }
      })
    },
  },
}
