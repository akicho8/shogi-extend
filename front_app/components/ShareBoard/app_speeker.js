import _ from "lodash"
import dayjs from "dayjs"
import SpeekerModal from "./SpeekerModal.vue"

export const app_speeker = {
  data() {
    return {
      messages: [],
    }
  },

  methods: {
    sx_click_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: SpeekerModal,
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

    speeker_share(params) {
      this.ac_room_perform("speeker_share", params) // --> app/channels/share_board/room_channel.rb
    },
    speeker_share_broadcasted(params) {
      if (params.message) {
        this.$buefy.toast.open({container: ".BoardWood", message: `${params.from_user_name}: ${params.message}`, position: "is-top", type: "is-white", queue: false})
        this.talk(params.message)
        this.ml_add(params)
      }
    },
  },
}
