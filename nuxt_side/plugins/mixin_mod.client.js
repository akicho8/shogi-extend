import Vue from "vue"

import { vue_application }       from "./application.client.js"
import { vue_actioncable }       from "./actioncable.client.js"
import { vue_storage }           from "./vue_storage.js"
import { vue_clipboard }         from "./vue_clipboard.js"
import { vue_sound }             from "./vue_sound.js"
import { vue_scroll       }  from "./vue_scroll.js"
import { vue_mounted_next }  from "./vue_mounted_next.js"
import { vue_support_nuxt_side } from "./vue_support_nuxt_side.js"

Vue.mixin({
  mixins: [
    vue_application,
    vue_storage,
    vue_clipboard,
    vue_sound,
    vue_actioncable,
    vue_scroll,
    vue_mounted_next,
    vue_support_nuxt_side,
  ],
})
