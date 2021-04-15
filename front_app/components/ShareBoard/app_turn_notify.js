import TurnNotifyModal from "./TurnNotifyModal.vue"

export const app_turn_notify = {
  data() {
    return {
      previous_user_name: null, // 上家の名前
    }
  },
  methods: {
    tn_notify() {
      this.sound_play_random(["moo1", "moo2", "moo3"])
      this.debug_alert("あなたの手番です")
    },

    tn_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: TurnNotifyModal,
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
}
