export const app_external_apps = {
  data() {
    return {
    }
  },

  watch: {
  },

  methods: {
    kifu_copy_handle() {
      this.sidebar_toggle()
      this.general_kifu_copy(this.current_question_sfen, {to_format: "kif"})
    },
    app_open(url) {
      this.url_open(url, this.target_default)
    },
    piyo_shogi_open_handle() {
      this.app_open(this.piyo_shogi_app_with_params_url)
    },
    kento_open_handle() {
      this.url_open(this.kento_app_with_params_url, "_blank")
    },
    share_board_open_handle() {
      this.sidebar_toggle()
      this.url_open(this.share_board_app_with_params_url, "_blank")
    },
  },

  computed: {
    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        sfen: this.sp_body,
        turn: 0,
        viewpoint: this.current_question_location_key,
        game_name: `実戦${this.current_question.mate}手詰 ${this.current_question.position}`,
      })
    },
    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.sp_body,
        turn: 0,
        viewpoint: this.current_question_location_key,
      })
    },
    share_board_app_with_params_url() {
      const route_info = this.$router.resolve({
        name: "share-board",
        query: {
          body: this.sp_body,
          turn: 0,
          abstract_viewpoint: this.sp_viewpoint,
          title: `やねうら王実戦${this.current_question.mate}手詰 ${this.current_question.position}`,
        },
      })
      return route_info.href
    },
  },
}
