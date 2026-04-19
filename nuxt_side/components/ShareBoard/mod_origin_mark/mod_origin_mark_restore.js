import { GX } from "@/components/models/gx.js"
import { GeneralMarkCollection } from "shogi-player/components/mod_general_mark/general_mark_collection.js"

export const mod_origin_mark_restore = {
  methods: {
    // 現在の状態から origin_mark_collection_str を作る (デバッグ用)
    sp_origin_mark_collection_display() {
      this.sp_call(e => console.log(e.mut_origin_mark_collection.to_serial))
    },
  },
  computed: {
    // 引数から印の配列を作る
    // 動作確認やデモ用
    // カンマで区切って3つずつ取り出す
    // http://localhost:4000/share-board?origin_mark_collection_str=7_7,alice,0,7_6,bob,1
    sp_origin_mark_collection() {
      return GeneralMarkCollection.from_serial(this.origin_mark_collection_str).to_a.map(e => e.attributes)
    },
  },
}
