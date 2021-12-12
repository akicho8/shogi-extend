import { MyLocalStorage } from "@/components/models/my_local_storage.js"

export const app_default_key = {
  data() {
    return {
      swars_search_default_key_blank_if_mounted: null, // マウントの時点でウォーズIDを記憶していたか？
    }
  },
  mounted() {
    this.swars_search_default_key_blank_if_mounted = this.blank_p(this.swars_search_default_key_get())
  },
  methods: {
    swars_search_default_key_get() {
      return MyLocalStorage.get("swars_search_default_key")
    },
  },
}
