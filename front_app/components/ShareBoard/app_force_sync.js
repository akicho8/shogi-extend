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
        sfen: this.current_sfen,
        turn_offset: this.turn_offset,
      }
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },

    force_sync_broadcasted(params) {
      // if (params.from_user_code === this.user_code) {
      //   this.debug_alert("自分受信")
      //   this.toast_ok(`${this.user_call_name(params.from_user_name)}の盤の状態をみんなに送ってセットしました`)
      // } else {
      //   this.debug_alert("相手受信")
      this.setup_by_params(params)
      this.toast_ok(`${this.user_call_name(params.from_user_name)}から送られてきた盤の状態に合わせました`)
      // }
    },
  },
}
