import vue_application from "./vue_application.js"
import vue_talk        from "./vue_talk.js"
import vue_support     from "./vue_support.js"
import vue_storage     from "./vue_storage.js"
import vue_fetch       from "./vue_fetch.js"
import vue_clipboard   from "./vue_clipboard.js"
import vue_sound       from "./vue_sound.js"
import vue_actioncable from "./vue_actioncable.js"
import vue_piyo_shogi  from "./vue_piyo_shogi.js"

export default {
  mixins: [
    vue_application,
    vue_talk,
    vue_support,
    vue_storage,
    vue_fetch,
    vue_clipboard,
    vue_sound,
    vue_actioncable,
    vue_piyo_shogi,
  ],
}
