// 確認方法: README_kifu_mail.org

import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export const mod_kifu_mail = {
  methods: {
    // 「メール送信」ボタンが押されたとき
    kifu_mail_handle() {
      this.$sound.play_click()
      // 部屋に入っているときは別ページに飛ぶと困るだろうから警告を出すに留める
      if (this.ac_room && !this.g_current_user) {
        this.toast_warn("ログインしてメールアドレスを適切に設定していると使えます")
        return
      }
      if (this.nuxt_login_required()) { return }
      this.kifu_mail_run()
    },
    // ログインユーザーがいる前提で直接実行する
    kifu_mail_run(options = {}) {
      Gs.__assert__(this.g_current_user, "this.g_current_user")
      options = {
        silent: false,     // true: 何も表示しない
        sb_judge_key: "none", // 勝ち負け (win, lose, none)
        ...options,
      }
      // そのまま KifuParser.new(params) できる形式にまとめる
      const params = {
        source: this.current_sfen,
        turn: this.current_turn,
        title: this.current_title,
        viewpoint: this.viewpoint,
        sb_judge_key: options.sb_judge_key,
        ...this.player_names,
      }
      // そのまま KifuParser で作るURLとフロント側で作ったパラメータに差異がないか確認するためのもの
      if (this.debug_mode_p) {
        params.__debug_app_urls__ = {
          share_board_url: this.current_url,
          piyo_url:        this.current_kifu_vo.piyo_url,
          kento_url:       this.current_kifu_vo.kento_url,
        }
      }
      this.$axios.$post("/api/share_board/kifu_mail.json", params, {progress: false}).then(e => {
        if (!options.silent) {
          this.toast_ok(e.message)
        }
      })
    },
  },
}
