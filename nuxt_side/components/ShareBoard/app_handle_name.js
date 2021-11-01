import { HandleNameValidator } from '@/components/models/handle_name_validator.js'
import HandleNameModal from "./HandleNameModal.vue"
import _ from "lodash"

export const app_handle_name = {
  methods: {
    // ハンドルネーム入力
    handle_name_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.handle_name_modal_core()
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
      this.member_info_bc_restart() // 新しい名前をBCする
    },

    handle_name_clear_handle() {
      this.handle_name_set("")
    },

    handle_name_validate(s) {
      if (this.$route.query.handle_name_validate_skip === "true") {
        return true
      }
      const message = HandleNameValidator.valid_with_message(s)
      if (message) {
        this.toast_warn(message)
        if (false) {
          this.sns_login_modal_open()
        }
        return false
      }
      return true
    },
  },
}
