import HandleNameModal from "./HandleNameModal.vue"
import _ from "lodash"

export const app_handle_name = {
  methods: {
    // ハンドルネーム入力
    handle_name_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      // https://buefy.org/documentation/modal/
      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "HandleNameModal",
        component: HandleNameModal,
        parent: this,
        props: { base: this.base },
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => this.sound_play("click"),
      })
    },

    handle_name_set(user_name) {
      this.user_name = user_name
      this.member_info_bc_restart() // 新しい名前をBCする
    },

    handle_name_clear_handle() {
      this.handle_name_set("")
    },

    handle_name_validate(s) {
      s = _.trim(s)
      let message = null
      if (message == null) {
        if (s.length === 0) {
          message = "ハンドルネームを入力してください"
        }
      }
      if (message == null) {
        if (s.match(/[な名][な無]し|nanash?i|無名|通りすがり/i)) {
          message = "そのハンドルネームは使えません"
        }
      }
      if (message == null) {
        if (s.length <= 1 && !s.match(/[一-龠]/)) {
          message = "正しいハンドルネームを入力してください"
        }
      }
      if (message) {
        this.toast_ng(message)
        if (false) {
          this.sns_login_modal_open()
        }
        return false
      }
      return true
    },
  },
}
