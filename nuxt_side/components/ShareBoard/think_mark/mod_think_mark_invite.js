import { GX } from "@/components/models/gx.js"
const share_board_think_mark_invite_png = require("@/assets/share_board/think_mark_invite.png")

export const mod_think_mark_invite = {
  data() {
    return {
      think_mark_invite_dialog_instance: null,
    }
  },
  beforeDestroy() {
    this.think_mark_invite_dialog_close()
  },
  methods: {
    think_mark_invite_to_watcher() {
      if (this.i_am_watcher_p) {
        if (this.think_mark_invite_feature_p) {
          this.think_mark_invite_dialog_show()
        }
      }
    },

    think_mark_invite_dialog_show() {
      this.sfx_play("se_notification")
      this.think_mark_invite_dialog_close()
      this.think_mark_invite_dialog_instance = this.dialog_confirm({
        title: `観戦者の${this.my_call_name}へ`,
        message: [
          `<div class="content">`,
          /**/ `<img src="${share_board_think_mark_invite_png}" />`,
          /**/ `<p class="mt-3">右クリックで自分の考えを示そう</p>`,
          /**/ `<p class="mt-2 is-size-7 has-text-grey">スマホの人は右上の鉛筆を押してから</p>`,
          `</div>`,
        ].join(""),
        confirmText: "わかった",
        cancelText: "見てるだけ",
        focusOn: "confirm",
        onConfirm: () => this.sfx_play("o"),
        onCancel: ()  => this.sfx_play("x"),
      })
    },

    think_mark_invite_dialog_close() {
      if (this.think_mark_invite_dialog_instance) {
        this.think_mark_invite_dialog_instance.close()
        this.think_mark_invite_dialog_instance = null
      }
    },
  },
}
