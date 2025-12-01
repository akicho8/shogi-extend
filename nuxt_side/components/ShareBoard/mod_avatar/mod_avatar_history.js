import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_avatar_history = {
  methods: {
    avatar_history_init() {
      this.avatar_history_ary = []
    },
    avatar_history_update() {
      if (GX.present_p(this.user_selected_avatar)) {
        const av = [].concat([this.user_selected_avatar], this.avatar_history_ary)
        const uniq_av = _.uniq(av)
        this.avatar_history_ary = GX.ary_take(uniq_av, this.AppConfig.avatar.avatar_history_take)
      }
    },
  },
  computed: {
    clund_avatars() {
      return _.uniq([].concat(this.avatar_history_ary, this.AvatarSupport.showcase_default_chars))
    },
  },
}
