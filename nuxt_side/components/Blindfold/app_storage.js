import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      talk_rate: null,
    }
  },
  mounted() {
    this.ls_setup()
  },
  computed: {
    default_talk_rate() {
      return 1.0
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin

    ls_storage_key() {
      return "blindfold"
    },

    ls_default() {
      return {
        talk_rate: this.default_talk_rate,
      }
    },
  },
}
