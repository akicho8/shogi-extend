import { GX } from "@/components/models/gx.js"

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
      const message = "${this.my_call_name}へ。暇だったら右クリックで自分の考えた指し手を示そう。"
      this.sb_talk(message)
      this.think_mark_invite_dialog_close()
      this.think_mark_invite_dialog_instance = this.dialog_confirm({
        title: `${this.my_call_name}へ`,
        message: `
<p>暇だったら右クリックで自分の考えた指し手を示そう</p>
<p class="is-size-7">スマホの場合は右上の鉛筆を有効にしよう</p>`,
        confirmText: "わかった",
        cancelText: "やだ",
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
