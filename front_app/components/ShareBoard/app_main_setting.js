import MainSettingModal from "./MainSettingModal.vue"

export const app_main_setting = {
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
