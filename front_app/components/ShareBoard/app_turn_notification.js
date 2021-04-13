import TurnNotificationModal from "./TurnNotificationModal.vue"

export const app_turn_notification = {
  data() {
    return {
      cn_from_user_name: null,
    }
  },
  methods: {
    tn_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: TurnNotificationModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
        props: {
          base: this.base,
        },
      })
    },
  },
  computed: {
  },
}
