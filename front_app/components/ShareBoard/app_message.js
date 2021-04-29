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
      this.sound_play("click")

      this.$buefy.modal.open({
        component: MessageSendModal,
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

    ////////////////////////////////////////////////////////////////////////////////

    message_share(params) {
      this.ac_room_perform("message_share", params) // --> app/channels/share_board/room_channel.rb
    },
    message_share_broadcasted(params) {
      if (params.message) {
        this.$buefy.toast.open({
          container: ".CustomShogiPlayer",
          message: `${params.from_user_name}: ${params.message}`,
          position: "is-bottom",
          type: "is-white",
          queue: false,
        })
        this.talk(params.message)
        this.ml_add(params)
      }
    },
  },
}
