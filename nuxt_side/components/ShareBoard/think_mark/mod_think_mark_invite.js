import { GX } from "@/components/models/gx.js"
const share_board_think_mark_invite_png = require("@/assets/share_board/think_mark_invite.png")

export const mod_think_mark_invite = {
  data() {
    return {
      think_mark_invite_dialog_instance: null,
    }
  },
  beforeDestroy() {
    this.__think_mark_invite_dialog_close()
  },
  methods: {
    // 思考印を使ってみないか促す
    // 対局開始時呼ばれる
    think_mark_invite_trigger() {
      if (this.think_mark_invite_feature_p) {
        if (this.i_am_watcher_p) {
          if (this.watching_member_many_p || this.AppConfig.think_mark_invite_watcher_count_skip) { // 自分以外に観戦者がいるときだけ出すなら
            this.think_mark_invite_dialog_show_for_watcher()
          }
        }
        if (this.i_am_member_p) {
          if (this.watching_member_exist_p || this.AppConfig.think_mark_invite_watcher_count_skip) { // 観戦者がいるときだけ出すなら
            this.think_mark_invite_dialog_show_for_member()
          }
        }
      }
    },

    // 観戦者用
    think_mark_invite_dialog_show_for_watcher() {
      this.__think_mark_invite_dialog_show({
        title: `観戦者の${this.my_call_name}へ`,
        message: [
          `<div>`,
          /**/ `<img src="${share_board_think_mark_invite_png}" />`,
          /**/ `<p class="mt-2 mb-0"><b>右クリック</b>で自分の指し手を書き込んで他の観戦者とセッションしよう</p>`,
          // /**/ `<p class="mt-2 mb-0 is-size-7 has-text-grey is-hidden-desktop">スマホの人は右上の鉛筆を押そう</p>`,
          `</div>`,
        ].join(""),
        confirmText: "わかった",
        cancelText: "いやです",
      })
    },

    // 対局者用
    think_mark_invite_dialog_show_for_member() {
      this.__think_mark_invite_dialog_show({
        title: `${this.my_call_name}の対局を${this.watching_member_count}人みています`,
        message: [
          `<div>`,
          /**/ `<img src="${share_board_think_mark_invite_png}" />`,
          /**/ `<p class="mt-2 mb-0">変化の多い局面では観戦者に向けて<b>右クリック</b>で指し手の候補を示してあげよう</p>`,
          // /**/ `<p class="mt-2 mb-0 is-size-7 has-text-grey is-hidden-desktop">スマホの人は右上の鉛筆を押そう</p>`,
          `</div>`,
        ].join(""),
        confirmText: "わかった",
        cancelText: "そんな余裕ないわ",
      })
    },

    __think_mark_invite_dialog_show(params) {
      params = {
        title: `(title)`,
        message: "(message)",
        confirmText: "(confirmText)",
        cancelText: "(cancelText)",
        focusOn: "confirm",
        canCancel: ["button"],
        onConfirm: () => {
          this.sfx_play("o")
          // GX.delay_block(0.5, () => this.toast_ok("ありがとうな"))
          this.ac_log({subject: "思考印導線", body: params.confirmText})
        },
        onCancel: () => {
          this.sfx_play("x")
          // GX.delay_block(0.5, () => this.toast_ok("なんじゃそれ"))
          this.ac_log({subject: "思考印導線", body: params.cancelText})
        },
        ...params,
      }
      this.sfx_play("se_notification")
      this.__think_mark_invite_dialog_close()
      this.think_mark_invite_dialog_instance = this.dialog_confirm(params)
    },

    __think_mark_invite_dialog_close() {
      if (this.think_mark_invite_dialog_instance) {
        this.think_mark_invite_dialog_instance.close()
        this.think_mark_invite_dialog_instance = null
      }
    },
  },
}
