import _ from "lodash"
import { GX } from "@/components/models/gs.js"

export const mod_taginput = {
  data() {
    return {
      taginput_filtered_tags: {}, // 入力するたびに候補のリストを入れる
    }
  },
  methods: {
    // 最初に候補を作っておく
    taginput_init(form_part) {
      this.taginput_typing_handle(form_part, "")
    },
    // 入力されるたびに実行する
    taginput_typing_handle(form_part, text) {
      text = GX.str_normalize_for_ac(text)
      const av = []
      _.each(form_part.elems, (value, key) => {
        if (GX.str_normalize_for_ac(key).indexOf(text) >= 0) {
          av.push(key)
        }
      })
      this.$set(this.taginput_filtered_tags, form_part.key, av)
    },
    // 追加した瞬間
    taginput_add_handle(form_part, tag) {
      this.sfx_play_toggle(true)
      this.talk(tag)
    },
    // 削除した瞬間
    taginput_remove_handle(form_part, tag) {
      this.sfx_play_toggle(false)
    },
  },
}
