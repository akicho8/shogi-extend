// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_universal from "./vue_mixins/vue_universal.js"
import vue_time      from "./vue_mixins/vue_time.js"
import vue_support   from "./vue_mixins/vue_support.js"

Vue.mixin({
  mixins: [
    vue_universal,
    vue_time,
    vue_support,
  ],
})
