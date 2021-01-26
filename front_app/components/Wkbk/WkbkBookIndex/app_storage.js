import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  created() {
    this.ls_setup() // fetch により先に呼ばれるので先に scope を設定できる
  },
  computed: {
    ls_default() {
      return {
        visible_hash: this.as_visible_hash(this.BookIndexColumnInfo.values),
        scope: this.default_scope,
      }
    },
  },
}
