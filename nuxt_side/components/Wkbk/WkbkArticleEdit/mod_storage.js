import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const mod_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      default_book_keys: null,
      default_lineage_key: null,
      default_folder_key: null,
    }
  },
  beforeMount() {
    this.ls_setup() // fetch により先に呼ばれるので先に scope を設定できる
  },
  computed: {
    ls_default() {
      return {
        default_book_keys: null,
        default_lineage_key: "次の一手",
        default_folder_key: "public",
      }
    },
  },
}
