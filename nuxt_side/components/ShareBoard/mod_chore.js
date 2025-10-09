import { ViewpointInfo } from "./models/viewpoint_info.js"
import _ from "lodash"

export const mod_chore = {
  methods: {
    // Windowアクティブチェック
    window_active_change_user_hook(focus_p) {
      // if (focus_p) {
      //   this.debug_alert(`sleep 5`)
      //   this.$gs.delay_block(5, () => {
      //     this.debug_alert(`Howler.unload()`)
      //     Howler.unload()
      //   })
      // } else {
      //   Howler.autoUnlock = true
      // }

      if (focus_p) {
        // PC の場合はよそ見中であってもチャットを受信するのでモバイルのときだけとしてもいいが、スマホが多数派なので分けないでいい
        this.mh_window_focus()
      }

      if (focus_p) {
        if (this.mobile_p) {
          this.sound_resume_modal_handle()
        }
      }

      if (this.$route.query.__system_test_now__) {
      } else {
        this.debug_alert(`画面:${focus_p}`)
      }

      if (this.debug_mode_p) {
        this.tl_add("画面焦点", focus_p ? "ON" : "OFF")
        this.ac_log({subject: "画面焦点", body: focus_p ? "ON" : "OFF"})
      }

      // インターバル実行の再スタートで即座にメンバー情報を反映する
      this.member_bc_restart()

      // ウィンドウを離れたらエントリー解除する
      if (!focus_p) {
        this.xmatch_window_blur()
      }
    },

    // 動画作成
    video_new_handle() {
      this.run_or_room_out_confirm(() => {
        this.$router.push({name: "video-new", query: {body: this.current_sfen, viewpoint: this.viewpoint}})
      })
    },

    // プロフィールアイコンを押して移動
    profile_click_handle(e) {
      this.run_or_room_out_confirm(() => this.$router.push("/lab/account"))
    },

    // ホームアイコンを押してトップに戻る
    exit_handle() {
      this.sfx_click()
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
      this.sfx_click()
      if (this.exit_warning_p) {
        this.room_out_confirm_dialog(block)
        return
      }
      block()
    },

    room_out_confirm_dialog(block = () => {}) {
      const message = "本当に退室してもよいですか？"
      this.sb_talk(message)
      this.dialog_confirm({
        title: "退室",
        message: message,
        confirmText: "退室する",
        focusOn: "cancel",
        onCancel: () => {
          this.sfx_click()
          this.ac_log({subject: "退室", body: "キャンセル"})
        },
        onConfirm: () => {
          this.sfx_click()
          this.ac_log({subject: "退室", body: "実行"})
          block()
        },
      })
    },

    exit_confirm_modal_for_clock_works(block = () => {}) {
      const message = "時計が動いていますが本当に終了してもよいですか？"
      this.sb_talk(message)
      this.dialog_confirm({
        title: "確認",
        message: message,
        confirmText: "終了する",
        focusOn: "cancel",
        onCancel: () => {
          this.sfx_click()
        },
        onConfirm: () => {
          this.sfx_click()
          block()
        },
      })
    },

    bold_if(cond) {
      if (cond) {
        return "has-text-weight-bold"
      }
    },

    // すべてのモーダルを閉じる
    all_modal_close() {
      this.gate_modal_close()
      this.cc_modal_close()
      this.os_modal_close()
    },
  },

  computed: {
    ViewpointInfo() { return ViewpointInfo },
    viewpoint_info() { return this.ViewpointInfo.fetch(this.viewpoint) },

    exit_warning_p() { return this.ac_room },                   // 退出時警告を出すか？

    // Home 表示条件
    // ・対局メンバーではない
    home_display_p() {
      return !this.i_am_member_p
    },
  },
}
