import MainSettingModal from "./MainSettingModal.vue"

export const app_main_setting = {
  data() {
    return {
      ctrl_mode:       null, // 対局時計が動作しているとき盤面下のコントローラーの表示有無
      yomiage_mode:    null, // 検討時の読み上げの有無
      sp_move_cancel:  null, // 検討時の読み上げの有無
      sync_mode:       null, // 同期方法
      internal_rule:   null, // 操作モードの内部ルール strict or free
      debug_mode:      null, // デバッグモード (bool型にしてはいけない)
      shout_key:       null, // 叫びモード
    }
  },
  created() {
    this.ctrl_mode       = this.$route.query.ctrl_mode       ?? this.DEFAULT_VARS.ctrl_mode
    this.debug_mode      = this.$route.query.debug_mode      ?? this.DEFAULT_VARS.debug_mode
    this.sync_mode       = this.$route.query.sync_mode       ?? this.DEFAULT_VARS.sync_mode
    this.internal_rule   = this.$route.query.internal_rule   ?? this.DEFAULT_VARS.internal_rule
    this.yomiage_mode    = this.$route.query.yomiage_mode    ?? this.DEFAULT_VARS.yomiage_mode
    this.avatar_king_key = this.$route.query.avatar_king_key ?? this.DEFAULT_VARS.avatar_king_key
    this.shout_key       = this.$route.query.shout_key       ?? this.DEFAULT_VARS.shout_key
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
    debug_mode_p() { return this.debug_mode === "is_debug_mode_on" },
    hard_sync_p()  { return this.sync_mode === "is_sync_mode_hard" },
    strict_p()     { return this.internal_rule === "strict"  },
  },
}
