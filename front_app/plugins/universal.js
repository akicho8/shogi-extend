// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_universal from "../../app/javascript/vue_mixins/vue_universal.js"

Vue.mixin({
  mixins: [
    vue_universal,
  ],
})
