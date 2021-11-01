import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      // default_book_keys: null,
      // default_lineage_key: null,
    }
  },
  beforeMount() {
    // this.ls_setup()
  },
  computed: {
    ls_default() {
      return {
        // default_book_keys: null,
        // default_lineage_key: "次の一手",
      }
    },
  },
}
