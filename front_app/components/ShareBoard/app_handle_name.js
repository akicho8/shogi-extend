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

      if (s.length === 0) {
        this.toast_ng("ハンドルネームを入力してください")
        return false
      } else if (s.match(/[一-龠]/)) {
        // OK
      } else if (s.length <= 1 || s.match(/[な名][な無]し|nanash?i|無名/i)) {
        if (false) {
          this.toast_ng("ログインしてください")
          this.sns_login_modal_open()
        } else {
          this.toast_ng("正しいハンドルネームを入力してください")
        }
        return false
      }

      return true
    },
  },
}
