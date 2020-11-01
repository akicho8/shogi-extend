// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_support    from "./vue_support.js"
import vue_time       from "./vue_time.js"
import vue_piyo_shogi from "./vue_piyo_shogi.js"
import vue_head       from "./vue_head.js"

import { mapState, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_support,
    vue_time,
    vue_piyo_shogi,
    vue_head,
  ],
  methods: {
    ...mapMutations("user", [
      "m_auth_user_logout",
    ]),
    ...mapActions('user', [
      "a_auth_user_fetch",
      "a_auth_user_logout",
    ]),
    // ...mapMutations("swars", [
    //   "m_remember_swars_user_keys_set",
    // ]),
  },
  computed: {
    ...mapState("user", [
      "g_current_user",
    ]),
    // ...mapState("swars", [
    //   "g_var1",
    // ]),
    development_p() {
      return process.env.NODE_ENV === "development"
    },
  },
})
