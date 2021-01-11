import ls_support from "@/components/models/ls_support.js"

export const app_storage = {
  mixins: [
    ls_support,
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

    //////////////////////////////////////////////////////////////////////////////// for ls_support

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
