import AbstractViewpointKeySelectModal from "./AbstractViewpointKeySelectModal.vue"
import _ from "lodash"

export const app_chore = {
  methods: {
    // Windowアクティブチェック
    window_active_change_user_hook(focus_p) {
      this.tl_add("画面焦点", focus_p ? "ON" : "OFF")
      this.ac_log("画面焦点", focus_p ? "ON" : "OFF")

      // インターバル実行の再スタートで即座にメンバー情報を反映する
      this.member_info_bc_restart()

      // ウィンドウを離れたらエントリー解除する
      if (!focus_p) {
        this.xmatch_window_blur()
      }
    },

    // 視点設定変更
    abstract_viewpoint_key_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: AbstractViewpointKeySelectModal,
        props: {
          abstract_viewpoint: this.abstract_viewpoint,
          permalink_for: this.permalink_for,
        },
        events: {
          "update:abstract_viewpoint": v => {
            this.abstract_viewpoint = v
          }
        },
      })
    },

    // タイトル編集
    title_edit_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.dialog_prompt({
        title: "タイトル",
        confirmText: "更新",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onConfirm: value => {
          this.sound_play("click")
          this.current_title_set(value)
        },
      })
    },

    // プロフィールアイコンを押して移動
    profile_click_handle(e) {
      this.exit_confirm_then(() => this.$router.push({name: "users-id", params: {id: this.g_current_user.id}}))
    },

    // ホームアイコンを押して退出
    exit_handle() {
      this.exit_confirm_then(() => this.$router.push({name: "index"}))
    },

    // 退出するときはとりあえずこれをかます
    exit_confirm_then(block = () => {}) {
      this.sound_play("click")
      if (!this.exit_warning_p) {
        block()
      } else {
        const message = "対局中のように見えますが本当に退室してもよいか？"
        this.talk(message)
        this.dialog_confirm({
          title: "退室",
          message: message,
          confirmText: "退室する",
          focusOn: "cancel",
          onCancel: () => {
            this.sound_stop_all()
            this.sound_play("click")
            this.ac_log("退室", "キャンセル")
          },
          onConfirm: () => {
            this.sound_stop_all()
            this.sound_play("click")
            this.ac_log("退室", "実行")
            block()
          },
        })
      }
    },
  },

  computed: {
    exit_warning_p() { return this.ac_room || this.clock_box }, // 退出時警告を出すか？
  },
}
