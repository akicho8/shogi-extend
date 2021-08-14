// 両方で定義したいものはここに入れる

import Vue from "vue"

import vue_support    from "./vue_support.js"
import vue_time       from "./vue_time.js"
import vue_browser_and_form      from "./vue_browser_and_form.js"
import vue_piyo_shogi from "./vue_piyo_shogi.js"
import vue_head       from "./vue_head.js"
import vue_talk       from "./vue_talk.js"

import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_support,
    vue_time,
    vue_browser_and_form,
    vue_piyo_shogi,
    vue_head,
    vue_talk,
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
    ...mapGetters("user", [
      "staff_p",
    ]),
    // ...mapState("swars", [
    //   "g_var1",
    // ]),
    development_p() {
      return process.env.NODE_ENV === "development"
    },
    development_or_staging_p() {
      return this.development_p || this.$config.STAGE === "staging"
    },
  },
})
