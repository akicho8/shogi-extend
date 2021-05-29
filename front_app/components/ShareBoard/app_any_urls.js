import { DotSfen } from "@/components/models/dot_sfen.js"

export const app_any_urls = {
  methods: {
    // 棋譜だけを含むURLのコピー
    url_without_room_code_copy_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.clipboard_copy({text: this.url_without_room_code})
    },
  },
  computed: {
    current_url_params() {
      const e = {
        ...this.$route.query,                  // デバッグ用パラメータを保持するため
        body:               DotSfen.escape(this.current_body), // 編集モードでもURLを更新するため
        turn:               this.turn_offset,
        title:              this.current_title,
        abstract_viewpoint: this.abstract_viewpoint,
        room_code:          this.room_code,
        sp_run_mode:        this.sp_run_mode,
        internal_rule:      this.internal_rule,
      }
      if (this.blank_p(e.room_code)) {
        delete e.room_code
      }
      if (this.blank_p(e.title) || e.title === this.DEFAULT_VARS.title) {
        delete e.title
      }
      if (e.sp_run_mode === this.DEFAULT_VARS.sp_run_mode) {
        delete e.sp_run_mode
      }
      if (e.internal_rule === this.DEFAULT_VARS.internal_rule) {
        delete e.internal_rule
      }
      return e
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
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
        game_name: this.current_title,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.current_sfen,
        turn: this.turn_offset,
        viewpoint: this.sp_viewpoint,
      })
    },

    // 棋譜だけを含むURL
    url_without_room_code() {
      const e = {...this.current_url_params}
      if (this.present_p(e.room_code)) {
        delete e.room_code
      }
      return this.permalink_from_params(e)
    },
  },
}
