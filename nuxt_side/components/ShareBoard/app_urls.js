import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
const TinyURL = require('tinyurl')

export const app_urls = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    room_code_only_url_copy_handle() {
      if (this.if_room_is_empty()) { return }

      this.__assert__(this.present_p(this.room_code), "this.present_p(this.room_code)")
      if (this.blank_p(this.room_code)) {
        // ここは通らないはず
        this.$sound.play_click()
        this.toast_warn("まだ合言葉を設定してません")
        return
      }

      this.sidebar_p = false
      this.$sound.play_click()
      this.clipboard_copy({text: this.room_code_only_url, success_message: "部屋のリンクをコピーしました"})
    },

    // 「棋譜コピー (リンク)」
    room_code_except_url_copy_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.clipboard_copy({text: this.room_code_except_url, success_message: "棋譜再生用のURLをコピーしました"})
    },

    // 「短縮URLのコピー」
    room_code_except_url_short_copy_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      TinyURL.shorten(this.room_code_except_url).then(res => {
        if (res === "Error") {
          this.toast_ng("なんかしらの原因で失敗しました")
          return
        }
        this.clipboard_copy({text: res, success_message: "棋譜再生用の短縮URLをコピーしました"})
      }, error => {
        console.error(error)
        this.toast_ng("失敗しました (ネットワークに繋っていない？)")
        return
      })
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.$sound.play_click()
      this.ga_click(app_name)
      this.remote_notify({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})

      this.shared_al_add({
        label: `${app_name}起動`,
        message: `${app_name}を起動しました`,
        // message_except_self: false,
        sfen: this.current_sfen,
        turn: this.current_turn,
      })
    },

    url_params_clean(url_params) {
      const params = this.pc_url_params_clean(url_params)
      if (this.blank_p(params.room_code)) {
        delete params.room_code
      }
      return params
    },
  },
  computed: {
    current_url_params() {
      const e = {
        // ...this.$route.query,                 // デバッグ用パラメータを保持するため ← これがあると xbody が残る
        // body: DotSfen.escape(this.current_sfen), // 編集モードでもURLを更新するため
        xbody:                SafeSfen.encode(this.current_sfen),
        turn:                 this.current_turn,
        title:                this.current_title,
        abstract_viewpoint:   this.abstract_viewpoint,
        room_code:            this.room_code,
        sp_run_mode:          this.sp_run_mode,
        legal_key: this.legal_key,
        color_theme_key:      this.color_theme_key,
        ...this.player_names,
      }
      return this.url_params_clean(e)
    },

    // URL
    current_url()      { return this.permalink_for()                 },
    json_debug_url()   { return this.permalink_for({format: "json"}) },
    twitter_card_url() { return this.permalink_for({format: "png"})  },

    // 外部アプリ
    piyo_shogi_app_with_params_url() {
      return this.$KifuVo.create({
        path: this.current_url,
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
        ...this.player_names_for_piyo,
      }).piyo_url
    },

    kento_app_with_params_url() {
      return this.$KifuVo.create({
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
      }).kento_url
    },

    kpedia_url() {
      return this.$KifuVo.create({sfen: this.short_sfen}).kpedia_url
    },

    // 合言葉だけを付与したURL
    // タイトルを含めるか試行錯誤したけどタイトルを含める利点はなかったので不要
    room_code_only_url() {
      const params = {
        room_code: this.room_code,
        // title: this.current_title,
      }
      return this.permalink_from_params(params)
    },

    // 棋譜だけを含むリンク
    room_code_except_url() {
      const params = {
        ...this.current_url_params,
      }

      // 除外するパラメータ
      delete params.room_code
      delete params.autoexec

      return this.permalink_from_params(params)
    },
  },
}
