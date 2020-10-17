// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_support    from "./vue_support.js"
import vue_time       from "./vue_time.js"
import vue_piyo_shogi from "./vue_piyo_shogi.js"

import { mapState, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_support,
    vue_time,
    vue_piyo_shogi,
  ],
  methods: {
    ...mapMutations("user", ["current_user_clear"]),
    ...mapActions('user', ["auth_user_fetch"]),
  },
  computed: {
    ...mapState("user", [
      "g_current_user",
    ]),
    development_p() {
      return process.env.NODE_ENV === "development"
    },
  },
})
