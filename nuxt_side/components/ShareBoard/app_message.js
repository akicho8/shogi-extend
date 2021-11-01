import _ from "lodash"
import dayjs from "dayjs"
import MessageSendModal from "./MessageSendModal.vue"

export const app_message = {
  data() {
    return {
      message_body: "",
    }
  },

  methods: {
    message_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: MessageSendModal,
        props: { base: this.base },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    message_share(params) {
      this.ac_room_perform("message_share", params) // --> app/channels/share_board/room_channel.rb
    },

    message_share_broadcasted(params) {
      if (!this.message_share_received_p(params)) {
        this.debug_alert(`「${params.message}」は表示されない`)
        return
      }

      this.$buefy.toast.open({
        container: ".MainBoard",
        message: `${params.from_user_name}: ${params.message}`,
        position: "is-top",
        type: params.message_scope === "ms_audience" ? "is-success" : "is-white",
        queue: false,
      })
      this.talk(params.message)
      this.ml_add(params)
    },

    // 受信したメッセージを表示してもよいか？
    message_share_received_p(e) {
      let exec = true
      if (e.message_scope === "ms_audience") {      // 観戦者宛のとき
        if (!this.received_from_self(e)) {          // 自分が送信者ではなく
          if (this.self_is_member_p) {              // 自分が対局者の場合は
            exec = false                            // 受信しない
          }
        }
      }
      return exec
    },
  },
}
