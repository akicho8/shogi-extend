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
      this.sfx_play("se_notification")
      this.think_mark_invite_dialog_close()
      this.think_mark_invite_dialog_instance = this.dialog_confirm({
        title: `観戦者の${this.my_call_name}へ`,
        message: [
          `<div class="content">`,
          /**/ `<img class="mb-2" src="${share_board_think_mark_invite_png}" />`,
          /**/ `<p>右クリックで自分の指し手を書き込んで他の観戦者とセッションしよう</p>`,
          /**/ `<p class="is-size-7 has-text-grey">スマホの人は右上の鉛筆を押してからな</p>`,
          `</div>`,
        ].join(""),
        confirmText: "わかった",
        cancelText: "いやです",
        focusOn: "confirm",
        onConfirm: () => this.sfx_play("o"),
        onCancel: ()  => this.sfx_play("x"),
      })
    },

    // 対局者用
    think_mark_invite_dialog_show_for_member() {
      this.sfx_play("se_notification")
      this.think_mark_invite_dialog_close()
      this.think_mark_invite_dialog_instance = this.dialog_confirm({
        title: `${this.my_call_name}の対局を${this.watching_member_count}人みています`,
        message: [
          `<div class="content">`,
          /**/ `<img class="mb-2" src="${share_board_think_mark_invite_png}" />`,
          /**/ `<p>ここぞという局面では観戦者に向けて指し手の選択肢を右クリックで示してあげよう</p>`,
          /**/ `<p class="is-size-7 has-text-grey">スマホの人は右上の鉛筆を押してからな</p>`,
          `</div>`,
        ].join(""),
        confirmText: "わかった",
        cancelText: "そんな余裕あるように見える？",
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
