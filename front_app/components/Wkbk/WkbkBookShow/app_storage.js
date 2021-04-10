import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"
import { ArticleTitleDisplayInfo } from "../models/article_title_display_info.js"
import { CorrectBehaviorInfo } from "../models/correct_behavior_info.js"
import { CorrectBehavior2Info } from "../models/correct_behavior2_info.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      article_title_display_key: null,
      correct_behavior_key: null,
      correct_behavior2_key: null,
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
        correct_behavior2_key: this.CorrectBehavior2Info.values[0].key,
      }
    },
    ArticleTitleDisplayInfo()    { return ArticleTitleDisplayInfo                                       },
    article_title_display_info() { return ArticleTitleDisplayInfo.fetch(this.article_title_display_key) },
    CorrectBehaviorInfo()        { return CorrectBehaviorInfo                                           },
    correct_behavior_info()      { return CorrectBehaviorInfo.fetch(this.correct_behavior_key)          },
    CorrectBehavior2Info()        { return CorrectBehavior2Info                                           },
    correct_behavior2_info()      { return CorrectBehavior2Info.fetch(this.correct_behavior2_key)          },
  },
}
