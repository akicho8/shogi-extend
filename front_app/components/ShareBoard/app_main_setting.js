import MainSettingModal from "./MainSettingModal.vue"

export const app_main_setting = {
  data() {
    return {
      ctrl_mode:     null, // 対局時計が動作しているとき盤面下のコントローラーの表示有無
      yomiage_mode:  null, // 検討時の読み上げの有無
      sync_mode:     null, // 同期方法
      internal_rule: null, // 操作モードの内部ルール strict or free
      debug_mode:    null, // デバッグモード (bool型にしてはいけない)
    }
  },
  created() {
    this.ctrl_mode     = this.$route.query.ctrl_mode || (this.development_p ? "is_ctrl_mode_visible" : "is_ctrl_mode_hidden")
    this.debug_mode    = this.$route.query.debug_mode || (this.development_p ? "is_debug_mode_on" : "is_debug_mode_off")
    this.sync_mode     = this.$route.query.sync_mode || (this.development_p ? "is_sync_mode_soft" : "is_sync_mode_soft")
    this.internal_rule = this.$route.query.internal_rule || this.default_internal_rule
    this.yomiage_mode  = this.$route.query.yomiage_mode || (this.development_p ? "is_yomiage_mode_on" : "is_yomiage_mode_on")
  },

  methods: {
    // for autoexec
    is_debug_mode_on()  { this.debug_mode = "is_debug_mode_on" },
    is_sync_mode_hard() { this.sync_mode = "is_sync_mode_hard" },

    general_setting_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: MainSettingModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
  computed: {
    default_internal_rule() { return "strict" },

    debug_mode_p() { return this.debug_mode === "is_debug_mode_on" },
    hard_sync_p()  { return this.sync_mode === "is_sync_mode_hard" },
    strict_p()     { return this.internal_rule === "strict"  },
  },
}
