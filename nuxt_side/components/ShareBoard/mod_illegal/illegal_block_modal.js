// 反則ブロック

import IllegalBlockModal from "./IllegalBlockModal.vue"
import { GX } from "@/components/models/gx.js"

export const illegal_block_modal = {
  data() {
    return {
      illegal_block_modal_instance: null,
    }
  },
  beforeDestroy() {
    this.illegal_block_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    illegal_block_modal_open() {
      this.illegal_block_modal_close()
      this.illegal_block_modal_instance = this.modal_card_open({
        component: IllegalBlockModal,
        canCancel: [],
        onCancel: () => { throw new Error("must not happen") },
      })
    },

    illegal_block_modal_close() {
      if (this.illegal_block_modal_instance) {
        this.illegal_block_modal_instance.close()
        this.illegal_block_modal_instance = null
        if (this.AppConfig.illegal_block.lifted_piece_cancel) {
          this.sp_lifted_piece_cancel()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    async illegal_block_modal_submit_handle(yes_or_no) {
      if (true) {
        const message = this.illegal_block_modal_submit_validate_message(yes_or_no)
        if (message) {
          this.sfx_play("x")
          for (const e of GX.ary_wrap(message)) {
            await this.toast_primary(e)
          }
          return
        }
      }

      this.sfx_click()
      this.illegal_block_modal_close()
      this.illegal_logging({yes_or_no: yes_or_no})
      this.illegal_block_yes_no(yes_or_no)
    },

    illegal_block_yes_no(yes_or_no) {
      GX.assert_present(this.illegal_params)
      const params = {
        ...this.illegal_params,
        yes_or_no_by: this.user_name,
        yes_or_no: yes_or_no,
      }
      this.ac_room_perform("illegal_block_yes_no", params) // --> app/channels/share_board/room_channel.rb
    },
    illegal_block_yes_no_broadcasted(params) {
      // this.al_add({...params, label: params.yes_or_no})

      // まだモーダルを読んでいる人がいるため閉じる
      this.illegal_block_modal_close()

      // 状況表示
      if (params.yes_or_no === "no") {
        this.sb_toast_primary(`${this.user_call_name(params.yes_or_no_by)}が反則をなかったことにしました`)
      }

      // 全員の局面を反則局面に変更する
      if (params.yes_or_no === "yes") {
        this.current_sfen_set(params)
      }

      // 最後に YES を押した人だけが投了する
      if (params.yes_or_no === "yes") {
        if (this.received_from_self(params)) {
          this.resign_call()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
