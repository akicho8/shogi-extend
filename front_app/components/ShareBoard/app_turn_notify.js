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
      this.debug_alert("(通知効果音)")
    },

    // user_name が指し終わったら自分の手番とする
    tn_previous_user_name_set(user_name) {
      if (this.previous_user_name === user_name) {
        if (this.previous_user_name) {
          this.toast_ok(`手番の通知は設定済みです`)
        } else {
          this.toast_ok(`手番の通知は未設定のままです`)
        }
      } else {
        if (user_name) {
          this.toast_ok(`${this.user_call_name(user_name)}が指したら牛が鳴きます`)
        } else {
          this.toast_ok(`解除しました`)
        }
        this.previous_user_name = user_name
      }
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
