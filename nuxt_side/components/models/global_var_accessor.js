import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export const global_var_accessor = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    ...mapMutations("global_var", [
    ]),

    ...mapMutations("global_var", [
      "__g_var1_set", // this.$store.commit("global_var/__g_var1_set", value) を this.__g_var1_set(value) と書けるようにする
      "__g_volume_talk_user_scale_set",
      "__g_volume_common_user_scale_set",
      "__g_toast_key_set",
    ]),
  },

  computed: {
    // // state を直接公開する場合
    // ...mapState("global_var", [
    //   "g_var1",
    // ]),
    //
    // // getters を公開する場合
    // ...mapGetters("global_var", [
    //   "g_var1_get",
    // ]),
    //
    // // attr_accessor :g_var1 相当
    // g_var1: {
    //   get()      { return this.$store.state.global_var.g_var1         },
    //   set(value) { this.$store.commit("global_var/__g_var1_set", value) },
    // },

    // attr_accessor :g_volume_talk_user_scale
    g_volume_talk_user_scale: {
      get()      { return this.$store.state.global_var.g_volume_talk_user_scale },
      set(value) { this.__g_volume_talk_user_scale_set(value)                   },
    },

    // attr_accessor :g_volume_common_user_scale
    g_volume_common_user_scale: {
      get()      { return this.$store.state.global_var.g_volume_common_user_scale },
      set(value) { this.__g_volume_common_user_scale_set(value)                   },
    },

    // attr_accessor :g_toast_key
    g_toast_key: {
      get()      { return this.$store.state.global_var.g_toast_key },
      set(value) { this.__g_toast_key_set(value)                   },
    },
  },
}
