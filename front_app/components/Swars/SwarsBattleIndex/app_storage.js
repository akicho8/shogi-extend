import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      visible_hash: null, //  { xxx: true, yyy: false } 形式
      display_key: null,  // 何の局面の表示をするか？
      remember_vs_user_keys: null,    // 対戦相手の補完リスト
    }
  },
  computed: {
    ls_storage_key() {
      return "swars/battles/index"
    },
    ls_default() {
      return {
        visible_hash: this.as_visible_hash(this.config.table_columns_hash),
        display_key:  this.config.display_key,
        remember_vs_user_keys: [],
      }
    },
  },
}
