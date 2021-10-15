import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    // this.ls_setup() // fetch により先に呼ばれるので先に search_preset_key を設定できる
  },
  computed: {
    ls_default() {
      return {
        // search_preset_key: this.default_scope,
      }
    },
  },
}
