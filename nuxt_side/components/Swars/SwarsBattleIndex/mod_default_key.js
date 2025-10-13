import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { GX } from "@/components/models/gs.js"

export const mod_default_key = {
  data() {
    return {
      mounted_then_swars_search_default_key_present_p: null, // マウントの時点でウォーズIDを記憶していたか？
    }
  },
  mounted() {
    this.mounted_then_swars_search_default_key_present_p = GX.present_p(this.swars_search_default_key_get())
  },
  methods: {
    // 記憶済みウォーズID取得
    swars_search_default_key_get() {
      return MyLocalStorage.get("swars_search_default_key")
    },
    // ウォーズID設定
    swars_search_default_key_set() {
      if (GX.present_p(this.xi.current_swars_user_key)) {
        MyLocalStorage.set("swars_search_default_key", this.xi.current_swars_user_key)
      }
    },
  },
}
