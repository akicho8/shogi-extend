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

      this.sidebar_p = false
      this.sfx_click()
      this.handle_name_modal_open()
    },

    // 本当は順番設定してなければ問題ないけどややこしくなるので退室してもらう
    handle_name_alert() {
      this.sidebar_p = false
      this.sfx_click()
      this.talk("入室後は名前を変更できません")
      // this.toast_ng("入室後はハンドルネームを変更できません。1️⃣ の「入退室」からいったん退室し、新しいハンドルネームで入り直してください。")
      this.dialog_confirm({
        title: "警告",
        message: `
            <div class="content">
              <p>入室後は名前を変更できません。</p>
              <p>変更するには<b>入退室</b>からいったん退室し、新しい名前で入り直してください。入退室はメニューの一番上にあります。</p>
              <p>もし、${this.my_safe_call_name}がすでに対局者だった場合は、入り直したあと、ホスト担当に<b>新しい名前で再度順番設定</b>をしてもらう(または自分で行う)必要があります。</p>
              <p>といった感じで、名前自体が識別子となっているため、途中で名前を変更するとクソ面倒なことになります。</p>
            </div>`,
        type: "is-warning",
        onConfirm: () => this.sfx_play("o"),
        onCancel: () => this.sfx_play("x"),
        confirmText: "理解した",
        cancelText: "何言ってんのかわからない",
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

    handle_name_clear() {
      this.handle_name_set("")
    },

    handle_name_invalid_then_show(user_name) {
      const message = HandleNameValidator.valid_message(user_name, {ng_word_check_p: this.ng_word_check_p})
      if (message) {
        this.toast_warn(message)
        return true
      }
      return false
    },
  },
  computed: {
    my_safe_call_name() { return this.user_call_name(this.user_name || "あなた") },
  },
}
