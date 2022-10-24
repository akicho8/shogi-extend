import { HandleNameValidator } from '@/components/models/handle_name_validator.js'
import HandleNameModal from "./HandleNameModal.vue"
import _ from "lodash"

export const app_handle_name = {
  methods: {
    // ハンドルネーム入力
    handle_name_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()

      if (this.order_enable_p) {
        this.handle_name_alert()
        return
      }

      this.handle_name_modal_core()
    },

    // <div class="content">
    //   <p>順番設定で現在のハンドルネームがすでに登録されているためいま変更してしまうと観戦者になってしまうかもしれません</p>
    //   <ul>
    //     <li>順番設定を解除する</li>
    //     <li>「部屋に入る」をタップして退室して再度入室する</li>
    //   </ul>
    // </div>
    handle_name_alert() {
      this.dialog_alert({
        title: "対局中の変更は危険",
        message: `
          <div class="content">
            <p>いったん順番設定を無効にしてください</p>
          </div>
        `,
        type: "is-danger",
        confirmText: "わかった",
      })
    },

    handle_name_modal_core(params = {}) {
      this.modal_card_open({
        component: HandleNameModal,
        props: {
          base: this.base,
          params: params,
        },
      })
    },

    handle_name_set(user_name) {
      this.user_name = user_name
      this.medal_write()
      this.member_bc_restart() // 新しい名前をBCする
    },

    handle_name_clear_handle() {
      this.handle_name_set("")
    },

    handle_name_validate(s) {
      if (this.$route.query.handle_name_validate === "false") {
        return true
      }
      const message = HandleNameValidator.valid_with_message(s)
      if (message) {
        this.toast_warn(message)
        if (false) {
          this.nuxt_login_modal_open()
        }
        return false
      }
      return true
    },
  },
}
