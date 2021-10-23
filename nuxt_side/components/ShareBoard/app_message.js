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
      if (params.message) {
        this.$buefy.toast.open({
          container: ".MainBoard",
          message: `${params.from_user_name}: ${params.message}`,
          position: "is-top",
          type: "is-white",
          queue: false,
        })
        this.talk(params.message)
        this.ml_add(params)
      }
    },
  },
}
