// import "../../app/javascript/packs/shared_app.js"

import Vue from 'vue'
import vue_all from "../../app/javascript/support/vue_all.js"

import Repository from "../../app/javascript/Repository.js"
Vue.prototype.$http = Repository

// // import vue_application from "../../app/javascript/support/vue_application.js"
// // import vue_support     from "../../app/javascript/support/vue_support.js"
// // import vue_storage     from "../../app/javascript/support/vue_storage.js"
// // import vue_fetch       from "../../app/javascript/support/vue_fetch.js"
// // import vue_clipboard   from "../../app/javascript/support/vue_clipboard.js"
// // import vue_sound       from "../../app/javascript/support/vue_sound.js"
// // import vue_actioncable from "../../app/javascript/support/vue_actioncable.js"
//
// // export default {
// //   mixins: [
// //     vue_all,
// //     // vue_application,
// //     // vue_support,
// //     // vue_storage,
// //     // vue_fetch,
// //     // vue_clipboard,
// //     // vue_sound,
// //     // vue_actioncable,
// //   ],
// // }
//
Vue.mixin({
  // mixins: [
  //   vue_application,
  //   vue_support,
  //   vue_storage,
  //   vue_fetch,
  //   vue_clipboard,
  //   vue_sound,
  //   vue_actioncable,
  // ],
  mixins: [
    vue_all,
  ],
})
