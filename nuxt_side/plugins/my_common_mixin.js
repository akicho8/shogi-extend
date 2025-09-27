// 両方で定義したいものはここに入れる

import Vue from "vue"

import { vue_support          } from "./vue_support.js"
import { vue_browser_and_form } from "./vue_browser_and_form.js"
import { vue_my_mobile         } from "./vue_my_mobile.js"
import { vue_head             } from "./vue_head.js"
import { vue_auth             } from "./vue_auth.js"
import { vue_shared_string    } from "./vue_shared_string.js"

import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_support,
    vue_browser_and_form,
    vue_my_mobile,
    vue_head,
    vue_auth,
    vue_shared_string,
  ],
  methods: {
    // なぜこんな苦行を強いられるのか謎

    ////////////////////////////////////////////////////////////////////////////////

    ...mapMutations("global_var", [
      "g_var1_set", // this.$store.commit("global_var/g_var1_set", value) を this.g_var1_set(value) と書けるようにするため
    ]),

    ...mapMutations("global_var", [
      "__g_talk_volume_scale_set", // this.$store.commit("global_var/__g_talk_volume_scale_set", value) を this.__g_talk_volume_scale_set(value) と書けるようにするため
    ]),

    ////////////////////////////////////////////////////////////////////////////////

    ...mapMutations("user", [
      "m_auth_user_logout",
    ]),
    ...mapActions("user", [
      "a_auth_user_fetch",
      "a_auth_user_logout",
      "a_auth_user_destroy",
    ]),
  },
  computed: {
    ////////////////////////////////////////////////////////////////////////////////

    // // state を直接公開する
    // ...mapState("global_var", [
    //   "g_var1",
    // ]),
    //
    // // getters を公開する
    // ...mapGetters("global_var", [
    //   "g_var1_get",
    // ]),
    //
    // // attr_accessor :g_var1 相当
    // g_var1: {
    //   get()      { return this.$store.state.global_var.g_var1         },
    //   set(value) { this.$store.commit("global_var/g_var1_set", value) },
    // },

    // attr_accessor :g_talk_volume_scale
    g_talk_volume_scale: {
      get()      { return this.$store.state.global_var.g_talk_volume_scale },
      set(value) { this.__g_talk_volume_scale_set(value)                   },
    },

    ////////////////////////////////////////////////////////////////////////////////

    ...mapState("user", [
      "g_current_user",
    ]),
    ...mapGetters("user", [
      "staff_p",
      "login_and_email_valid_p",
      "g_current_user_name",
    ]),
    ...mapGetters(["g_loading_p"]),
    // ...mapState("swars", [
    // ]),
    development_p() {
      return process.env.NODE_ENV === "development"
    },
  },
})
