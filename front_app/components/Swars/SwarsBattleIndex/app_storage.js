import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    // ls_support_mixin,
  ],
  data() {
    return {
      // tab_index: null,
    }
  },
  computed: {
    ls_default() {
      return {
        // tab_index: 0,
      }
    },
  },
}
