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

    async illegal_takeback_modal_submit_handle(i_selected) {
      if (true) {
        const message = this.illegal_takeback_modal_submit_validate_message(i_selected)
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
      this.illegal_takeback_selected_share(i_selected)
    },

    illegal_takeback_selected_share(i_selected) {
      GX.assert_present(this.illegal_params)
      this.illegal_logging({i_selected: i_selected})
      const params = {
        ...this.illegal_params, // デバッグしやすいように入れておく
        i_selected_by: this.user_name,
        i_selected: i_selected,
      }
      this.ac_room_perform("illegal_takeback_selected_share", params) // --> app/channels/share_board/room_channel.rb
    },
    illegal_takeback_selected_share_broadcasted(params) {
      // 途中から入ってきた人は this.illegal_params を持っていないため関わらないようにする
      if (this.illegal_params == null) {
        return
      }

      // this.al_add({...params, label: params.i_selected})

      // まだモーダルを読んでいる人がいるため閉じる
      this.illegal_takeback_modal_close()

      if (params.i_selected === "do_takeback") {
        // 時計が pause 状態になっているので「なかったことにする」のであれば再開する
        this.cc_resume_handle()

        // 状況表示
        this.sb_toast_primary(this.illegal_user_info.blocked_message(this, params))
      }

      if (params.i_selected === "do_resign") {
        // 全員の局面を反則局面に変更する
        this.current_sfen_set(params)

        // 最後に YES を押した人だけが投了する
        if (this.received_from_self(params)) {
          this.resign_call()
        }
      }

      this.illegal_params_reset()
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
