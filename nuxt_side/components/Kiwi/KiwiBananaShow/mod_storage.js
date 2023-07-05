import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const mod_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
    }
  },
  beforeMount() {
    this.ls_setup()
  },
  computed: {
    ls_default() {
      return {
        message_body: "",
      }
    },
  },
}
