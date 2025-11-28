import { HandleNameValidator } from '@/components/models/handle_name/handle_name_validator.js'
import HandleNameModal from "./HandleNameModal.vue"
import _ from "lodash"

export const mod_handle_name = {
  methods: {
    // ハンドルネーム入力
    handle_name_modal_handle() {
      if (this.ac_room) {
        this.handle_name_alert()
        return
      }

      this.sidebar_close()
      this.sfx_click()
      this.handle_name_modal_open()
    },

    // 本当は順番設定してなければ問題ないけどややこしくなるので退室してもらう
    handle_name_alert() {
      this.sidebar_close()
      this.sfx_click()
      this.talk("入室後は名前を変更できません")
      // this.toast_danger("入室後はハンドルネームを変更できません。1️⃣ の「入退室」からいったん退室し、新しいハンドルネームで入り直そう。")
      this.dialog_confirm({
        title: "警告",
        message: `
            <div class="content">
              <p>入室後は名前を変更できないので<b>いったん退室し、新しい名前で入り直して</b>ください。退室はメニューの一番上です。</p>
              <p>また、${this.my_call_name}がすでに対局者だった場合は、入り直したあとホスト担当に<b>新しい名前で再度順番設定</b>をしてもらう必要があります。</p>
              <p>といった感じで名前自体が識別子のため途中で名前を変えると面倒なことになります。</p>
            </div>`,
        // type: "is-warning",
        onConfirm: () => this.sfx_play("o"),
        onCancel: () => this.sfx_play("x"),
        confirmText: "わかった",
        cancelText: "わからん",
      })
    },

    handle_name_modal_open(params = {}) {
      this.modal_card_open({
        component: HandleNameModal,
        props: {
          params: params,
        },
      })
    },

    handle_name_set(user_name) {
      this.user_name = user_name
      this.xprofile_reload()        // バッジと名前を結び付ける
      this.member_bc_restart()      // 新しい名前をBCする
    },

    // デバッグ用
    handle_name_clear() {
      this.user_name = ""
    },

    handle_name_invalid_then_show(user_name) {
      const message = this.handle_name_invalid_message(user_name)
      if (message) {
        this.toast_warn(message)
        this.app_log({emoji: ":名前違反:", subject: "共有将棋盤 名前違反", body: {user_name: user_name, message: message}})
        return true
      }
      return false
    },

    // private

    handle_name_invalid_message(user_name) {
      return HandleNameValidator.valid_message(user_name, {ng_word_check_p: this.ng_word_check_p})
    },
  },
  computed: {
    my_call_name() { return this.user_call_name(this.user_name || "あなた") },
  },
}
