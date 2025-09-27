import { HandleNameValidator } from '@/components/models/handle_name/handle_name_validator.js'
import HandleNameModal from "./HandleNameModal.vue"
import _ from "lodash"

export const mod_handle_name = {
  methods: {
    // ハンドルネーム入力
    handle_name_modal_handle() {
      this.sidebar_p = false
      this.sfx_play_click()

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
    //     <li>「入退室」をタップして退室して再度入室する</li>
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
          params: params,
        },
      })
    },

    handle_name_set(user_name) {
      this.user_name = user_name
      this.handle_name_updated()
    },

    handle_name_updated() {
      this.badge_write()       // バッジと名前を結び付ける
      this.member_bc_restart() // 新しい名前をBCする
    },

    handle_name_clear_handle() {
      this.handle_name_set("")
    },

    handle_name_invalid_then_toast_warn(s) {
      if (this.$route.query.handle_name_validate === "false") {
        return false
      }
      const message = HandleNameValidator.valid_message(s)
      if (message) {
        this.toast_warn(message)
        return true
      }
      return false
    },
  },
}
