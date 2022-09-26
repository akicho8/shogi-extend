import AbstractViewpointKeySelectModal from "./AbstractViewpointKeySelectModal.vue"
import { AbstractViewpointInfo } from "./models/abstract_viewpoint_info.js"

import _ from "lodash"

export const app_chore = {
  methods: {
    // Windowアクティブチェック
    window_active_change_user_hook(focus_p) {
      // if (focus_p) {
      //   this.debug_alert(`sleep 5`)
      //   this.delay_block(5, () => {
      //     this.debug_alert(`Howler.unload()`)
      //     Howler.unload()
      //   })
      // } else {
      //   Howler.autoUnlock = true
      // }

      if (focus_p) {
        if (this.mobile_p()) {
          this.sound_resume_modal_handle()
        }
      }

      this.debug_alert(`画面:${focus_p}`)

      if (this.debug_mode_p) {
        this.tl_add("画面焦点", focus_p ? "ON" : "OFF")
        this.ac_log("画面焦点", focus_p ? "ON" : "OFF")
      }

      // インターバル実行の再スタートで即座にメンバー情報を反映する
      this.member_bc_restart()

      // ウィンドウを離れたらエントリー解除する
      if (!focus_p) {
        this.xmatch_window_blur()
      }
    },

    // 視点設定変更
    abstract_viewpoint_key_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: AbstractViewpointKeySelectModal,
        props: { base: this.base },
      })
    },

    // タイトル編集
    title_edit_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.dialog_prompt({
        title: "タイトル",
        confirmText: "更新",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onConfirm: value => {
          this.sound_play_click()
          this.current_title_set(value)
        },
      })
    },

    // 動画作成
    video_new_handle() {
      this.run_or_room_out_confirm(() => {
        this.$router.push({name: "video-new", query: {body: this.current_sfen, viewpoint_key: this.sp_viewpoint}})
      })
    },

    // プロフィールアイコンを押して移動
    profile_click_handle(e) {
      this.run_or_room_out_confirm(() => {
        this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      })
    },

    // ホームアイコンを押してトップに戻る
    exit_handle() {
      this.sound_play_click()
      if (this.exit_warning_p) {
        this.run_or_room_out_confirm(() => this.room_destroy())
        return
      }
      if (this.clock_box && this.clock_box.play_p) {
        this.exit_confirm_modal_for_clock_works(() => this.$router.push({name: "index"}))
        return
      }
      this.$router.push({name: "index"})
    },

    // 外に出るときはこれをかます
    run_or_room_out_confirm(block = () => {}) {
      this.sound_play_click()
      if (this.exit_warning_p) {
        this.room_out_confirm_dialog(block)
        return
      }
      block()
    },

    room_out_confirm_dialog(block = () => {}) {
      const message = "本当に退室してもよいですか？"
      this.talk(message)
      this.dialog_confirm({
        title: "退室",
        message: message,
        confirmText: "退室する",
        focusOn: "cancel",
        onCancel: () => {
          this.sound_play_click()
          this.ac_log("退室", "キャンセル")
        },
        onConfirm: () => {
          this.sound_play_click()
          this.ac_log("退室", "実行")
          block()
        },
      })
    },

    exit_confirm_modal_for_clock_works(block = () => {}) {
      const message = "時計が動いていますが本当に終了してもよいですか？"
      this.talk(message)
      this.dialog_confirm({
        title: "確認",
        message: message,
        confirmText: "終了する",
        focusOn: "cancel",
        onCancel: () => {
          this.sound_play_click()
        },
        onConfirm: () => {
          this.sound_play_click()
          block()
        },
      })
    },

    bold_if(cond) {
      if (cond) {
        return "has-text-weight-bold"
      }
    },
  },

  computed: {
    AbstractViewpointInfo() { return AbstractViewpointInfo },
    abstract_viewpoint_info() { return this.AbstractViewpointInfo.fetch(this.abstract_viewpoint) },

    exit_warning_p() { return this.ac_room },                   // 退出時警告を出すか？

    // Home 表示条件
    home_display_p() {
      if (this.self_is_member_p) {
        return false
      }
      return true
    }
  },
}
