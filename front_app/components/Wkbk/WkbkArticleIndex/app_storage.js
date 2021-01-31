import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  created() {
    this.clog("created process.client", process.client)
    this.clog("created process.server", process.server)

    this.ls_setup() // fetch により先に呼ばれるので先に scope を設定できる
    this.clog("created visible_hash", this.visible_hash)
    this.clog("created scope", this.scope)
  },
  computed: {
    ls_default() {
      return {
        visible_hash: this.as_visible_hash(this.ArticleIndexColumnInfo.values),
        scope: this.default_scope,
      }
    },
  },
}
