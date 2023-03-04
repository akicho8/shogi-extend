import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import { VisibleUtil } from "@/components/models/visible_util.js"

export const mod_storage = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    // this.ls_setup() // fetch により先に呼ばれるので先に scope を設定できる
  },
  computed: {
    ls_default() {
      return {
        // visible_hash: VisibleUtil.as_visible_hash(this.BookIndexColumnInfo.values),
        // scope: this.default_scope,
      }
    },
  },
}
