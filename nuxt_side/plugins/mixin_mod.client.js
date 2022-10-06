import Vue from "vue"

import { vue_application       } from "./application.client.js"
import { vue_actioncable       } from "./actioncable.client.js"
import { vue_clipboard         } from "./vue_clipboard.js"
import { vue_scroll            } from "./vue_scroll.js"
import { vue_mounted_next      } from "./vue_mounted_next.js"
import { vue_support_nuxt_side } from "./vue_support_nuxt_side.js"
import { vue_talk              } from "./vue_talk.js"

import { SoundUtil } from "@/components/models/sound_util.js"

Vue.mixin({
  mixins: [
    vue_application,
    vue_clipboard,
    vue_actioncable,
    vue_scroll,
    vue_mounted_next,
    vue_support_nuxt_side,
    vue_talk,
  ],
  methods: {
    ...SoundUtil,
  },
})
