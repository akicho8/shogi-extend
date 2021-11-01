import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  beforeMount() {
    // created() で fetch により先に呼ばれるので先に scope を設定できる
    // とおもったけどなんか不安定。beforeMount() だと安定
    this.ls_setup()
  },
  computed: {
    ls_default() {
      return {
        visible_hash: this.as_visible_hash(this.ArticleIndexColumnInfo.values),
        // scope: this.default_scope,
      }
    },
  },
}
