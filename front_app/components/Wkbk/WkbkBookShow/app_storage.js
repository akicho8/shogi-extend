import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import { ArticleTitleDisplayInfo } from "../models/article_title_display_info.js"
import { CorrectBehaviorInfo } from "../models/correct_behavior_info.js"

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
        article_title_display_key: this.ArticleTitleDisplayInfo.values[0].key,
        correct_behavior_key: this.CorrectBehaviorInfo.values[0].key,
      }
    },
    ArticleTitleDisplayInfo()    { return ArticleTitleDisplayInfo                                       },
    article_title_display_info() { return ArticleTitleDisplayInfo.fetch(this.article_title_display_key) },
    CorrectBehaviorInfo()        { return CorrectBehaviorInfo                                           },
    correct_behavior_info()      { return CorrectBehaviorInfo.fetch(this.correct_behavior_key)          },
  },
}
