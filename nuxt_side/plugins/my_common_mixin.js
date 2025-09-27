// 両方で定義したいものはここに入れる

import Vue from "vue"

import { vue_support          } from "./vue_support.js"
import { vue_browser_and_form } from "./vue_browser_and_form.js"
import { vue_my_mobile        } from "./vue_my_mobile.js"
import { vue_head             } from "./vue_head.js"
import { vue_auth             } from "./vue_auth.js"
import { vue_shared_string    } from "./vue_shared_string.js"
import { global_var_accessor  } from "@/components/models/global_var_accessor.js"

import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

Vue.mixin({
  mixins: [
    vue_support,
    vue_browser_and_form,
    vue_my_mobile,
    vue_head,
    vue_auth,
    vue_shared_string,
    global_var_accessor,
  ],
  methods: {
    // なぜこんな苦行を強いられるのか謎

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
    development_p() { return process.env.NODE_ENV === "development" },
    production_p()  { return !this.development_p },
  },
})
