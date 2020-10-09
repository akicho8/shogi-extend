import Vue from "vue"

// import vue_mixins from "../../app/javascript/vue_mixins/vue_mixins.js"

import vue_application from "./vue_mixins/vue_application.js"
import vue_support     from "./vue_mixins/vue_support.js"
import vue_time        from "./vue_mixins/vue_time.js"
import vue_storage     from "./vue_mixins/vue_storage.js"
import vue_clipboard   from "./vue_mixins/vue_clipboard.js"
import vue_sound       from "./vue_mixins/vue_sound.js"
import vue_actioncable from "./vue_mixins/vue_actioncable.js"
import vue_piyo_shogi  from "./vue_mixins/vue_piyo_shogi.js"
import vue_talk        from "./vue_mixins/vue_talk.js"
import vue_fetch       from "./vue_mixins/vue_fetch.js"

import vue_support_nuxt_side from "./vue_support_nuxt_side.js"

Vue.mixin({
  mixins: [
    vue_application,
    vue_support,
    vue_time,
    vue_storage,
    vue_clipboard,
    vue_sound,
    vue_actioncable,
    vue_piyo_shogi,

    vue_fetch,
    vue_talk,
    vue_support_nuxt_side,
  ],
})
