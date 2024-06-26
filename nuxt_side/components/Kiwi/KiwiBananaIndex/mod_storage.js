import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import { VisibleUtil } from "@/components/models/visible_util.js"

export const mod_storage = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    this.ls_setup()             // created() のなかで呼ぶと動かないのはなぜ？？？
  },
  computed: {
    ls_default() {
      return {
        // visible_hash: VisibleUtil.as_visible_hash(this.BananaIndexColumnInfo.values),
        // scope: this.default_scope,
      }
    },
  },
}
