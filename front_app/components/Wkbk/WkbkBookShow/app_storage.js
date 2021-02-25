import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      article_title_display_key: null,
      correct_behavior_key: null,
    }
  },

  beforeMount() {
    this.ls_setup()
  },

  computed: {
    ls_default() {
      return {
        article_title_display_key: "display",
        correct_behavior_key: "go_to_next",
      }
    },
  },
}
