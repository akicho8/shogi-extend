import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export const global_var_accessor = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    ...mapMutations("global_var", [
    ]),

    ...mapMutations("global_var", [
      "__g_var1_set", // this.$store.commit("global_var/__g_var1_set", value) を this.__g_var1_set(value) と書けるようにする
      "__g_talk_volume_scale_set",
      "__g_common_volume_scale_set",
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

    // attr_accessor :g_talk_volume_scale
    g_talk_volume_scale: {
      get()      { return this.$store.state.global_var.g_talk_volume_scale },
      set(value) { this.__g_talk_volume_scale_set(value)                   },
    },

    // attr_accessor :g_common_volume_scale
    g_common_volume_scale: {
      get()      { return this.$store.state.global_var.g_common_volume_scale },
      set(value) { this.__g_common_volume_scale_set(value)                   },
    },

    // attr_accessor :g_toast_key
    g_toast_key: {
      get()      { return this.$store.state.global_var.g_toast_key },
      set(value) { this.__g_toast_key_set(value)                   },
    },
  },
}
