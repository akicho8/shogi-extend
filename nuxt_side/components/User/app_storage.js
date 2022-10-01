import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      piyo_shogi_type_key: null,
    }
  },
  beforeMount() {
    this.ls_setup() // fetch により先に呼ばれるので先に scope を設定できる
  },
  computed: {
    ls_storage_key() {
      return "user_settings"
    },
    ls_default() {
      return {
        piyo_shogi_type_key: "auto",
      }
    },
  },
}
