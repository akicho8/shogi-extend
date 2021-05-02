// import _ from "lodash"
// import dayjs from "dayjs"
import ForceSyncModal from "./ForceSyncModal.vue"

export const app_force_sync = {
  methods: {
    force_sync_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: ForceSyncModal,
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

    force_sync() {
      const params = {
        ...this.current_sfen_attrs,
        message: "同期",
      }
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },

    force_sync_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        this.debug_alert("自分受信")
      } else {
        this.debug_alert("相手受信")
        this.setup_by_params(params)
      }
      if (params.message) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${params.message}`)
      }
    },
  },
}
