// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_time      from "./vue_mixins/vue_time.js"
import vue_support   from "./vue_mixins/vue_support.js"

import { mapState, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_time,
    vue_support,
  ],
  computed: {
    ...mapState("user", [
      "g_current_user",
    ]),
    development_p() {
      return process.env.NODE_ENV === "development"
    },
  },
})
