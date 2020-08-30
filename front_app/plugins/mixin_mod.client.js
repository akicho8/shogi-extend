import Vue from "vue"

// import vue_mixins from "../../app/javascript/vue_mixins/vue_mixins.js"

import vue_application from "../../app/javascript/vue_mixins/vue_application.js"
import vue_support     from "../../app/javascript/vue_mixins/vue_support.js"
import vue_time        from "../../app/javascript/vue_mixins/vue_time.js"
import vue_storage     from "../../app/javascript/vue_mixins/vue_storage.js"
import vue_clipboard   from "../../app/javascript/vue_mixins/vue_clipboard.js"
import vue_sound       from "../../app/javascript/vue_mixins/vue_sound.js"
import vue_actioncable from "../../app/javascript/vue_mixins/vue_actioncable.js"
import vue_piyo_shogi  from "../../app/javascript/vue_mixins/vue_piyo_shogi.js"

// Nuxt側で独自定義したもの
import vue_talk        from "./vue_talk.js"
import vue_fetch       from "./vue_fetch.js"

// import axios_support from "../../app/javascript/axios_support.js"
// Vue.prototype.$http = axios_support

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
  ],
})
