import Vue from "vue"
import vue_mixins from "../../app/javascript/vue_mixins/vue_mixins.js"

import axios_support from "../../app/javascript/axios_support.js"
Vue.prototype.$http = axios_support

Vue.mixin({
  mixins: [
    vue_mixins,
  ],
})
