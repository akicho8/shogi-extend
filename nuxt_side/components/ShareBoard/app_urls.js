import { DotSfen } from "@/components/models/dot_sfen.js"

export const app_urls = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    room_code_only_url_copy_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      if (!this.room_code) {
        this.toast_warn("まだ合言葉を設定してません")
        return
      }
      this.clipboard_copy({text: this.room_code_only_url, success_message: "部屋のリンクをコピーしました"})
    },

    // 「棋譜コピー (リンク)」
    room_code_except_url_copy_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.clipboard_copy({text: this.room_code_except_url})
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.sound_play_click()

      this.shared_al_add({
        label: `${app_name}起動`,
        message: `${app_name}を起動しました`,
        // message_except_self: false,
        sfen: this.current_sfen,
        turn: this.current_turn,
      })
    },

    url_params_clean(url_params) {
      const params = {...url_params}
      if (this.blank_p(params.room_code)) {
        delete params.room_code
      }
      this.ParamInfo.values.forEach(e => {
        const v = params[e.key]
        if (this.blank_p(v) || v === e.default_for(this)) {
          delete params[e.key]
        }
      })
      return params
    },

  },
  computed: {
    current_url_params() {
      const e = {
        ...this.$route.query,                  // デバッグ用パラメータを保持するため
        body: DotSfen.escape(this.current_sfen), // 編集モードでもURLを更新するため
        turn:                 this.current_turn,
        title:                this.current_title,
        abstract_viewpoint:   this.abstract_viewpoint,
        room_code:            this.room_code,
        sp_run_mode:          this.sp_run_mode,
        sp_internal_rule_key: this.sp_internal_rule_key,
        color_theme_key:      this.color_theme_key,
      }
      return this.url_params_clean(e)
    },

    // URL
    current_url()      { return this.permalink_for()                 },
    json_debug_url()   { return this.permalink_for({format: "json"}) },
    twitter_card_url() { return this.permalink_for({format: "png"})  },

    // 外部アプリ
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        path: this.current_url,
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
        game_name: this.current_title,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
      })
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
