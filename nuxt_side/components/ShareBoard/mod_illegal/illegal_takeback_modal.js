// 反則ブロック

import IllegalTakebackModal from "./IllegalTakebackModal.vue"
import { GX } from "@/components/models/gx.js"

export const illegal_takeback_modal = {
  data() {
    return {
      illegal_takeback_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.illegal_takeback_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    illegal_takeback_modal_open() {
      this.illegal_takeback_modal_close()
      this.illegal_takeback_modal_instance = this.modal_card_open({
        component: IllegalTakebackModal,
        canCancel: [],
        onCancel: () => { throw new Error("must not happen") },
      })
    },

    illegal_takeback_modal_close() {
      if (this.illegal_takeback_modal_instance) {
        this.illegal_takeback_modal_instance.close()
        this.illegal_takeback_modal_instance = null
        if (this.AppConfig.illegal_takeback.lifted_piece_cancel) {
          this.sp_lifted_piece_cancel()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    async illegal_takeback_modal_submit_handle(illegal_select_key) {
      if (true) {
        const message = this.illegal_takeback_modal_submit_validate_message(illegal_select_key)
        if (message) {
          this.sfx_play("x")
          for (const e of GX.ary_wrap(message)) {
            await this.toast_primary(e)
          }
          return
        }
      }

      this.sfx_click()
      this.illegal_takeback_modal_close()
      this.illegal_takeback_selected_share(illegal_select_key)
    },

    illegal_takeback_selected_share(illegal_select_key) {
      GX.assert_present(this.illegal_params)

      const illegal_select_info = this.IllegalSelectInfo.fetch(illegal_select_key)
      this.ac_log({subject: "反則ブロック選択", body: [this.latest_illegal_name, illegal_select_info.name]})

      const params = {
        ...this.illegal_params, // デバッグしやすいように入れておく
        selected_by: this.user_name,
        illegal_select_key: illegal_select_key,
      }
      this.ac_room_perform("illegal_takeback_selected_share", params) // --> app/channels/share_board/room_channel.rb
    },
    illegal_takeback_selected_share_broadcasted(params) {
      // 途中から入ってきた人は this.illegal_params を持っていないため関わらないようにする
      if (this.illegal_params == null) {
        return
      }

      // まだモーダルを読んでいる人がいるため閉じる
      this.illegal_takeback_modal_close()

      const illegal_select_info = this.IllegalSelectInfo.fetch(params.illegal_select_key)
      this.al_add({...params, label: illegal_select_info.name, label_type: "is-danger"})
      illegal_select_info.call(this, params)

      this.illegal_params_reset()
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
