import { MyLocalStorage } from "@/components/models/my_local_storage.js"

export const mod_default_key = {
  data() {
    return {
      mounted_then_swars_search_default_key_present_p: null, // マウントの時点でウォーズIDを記憶していたか？
    }
  },
  mounted() {
    this.mounted_then_swars_search_default_key_present_p = this.present_p(this.swars_search_default_key_get())
  },
  methods: {
    // 記憶済みウォーズID取得
    swars_search_default_key_get() {
      return MyLocalStorage.get("swars_search_default_key")
    },
  },
}
