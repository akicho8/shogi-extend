export const app_articles = {
  data() {
    return {
      current_index: null, // 問題インデックス
    }
  },

  methods: {
    setup_first() {
      this.current_index = 0
    },

    next_handle() {
      this.sound_play("o")
      this.current_index += 1
    },

    restart_handle() {
      this.sound_play("o")
      this.setup_first()
    },

    play_mode_advanced_moves_set(moves) {
      if (this.current_article.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
      }
    },
  },

  computed: {
    articles()             { return this.book.articles                                      }, // 問題配列
    rest_count()           { return this.max_count - this.current_index                     }, // 残り問題数
    max_count()            { return this.articles.length                                    }, // 問題数
    goal_p()               { return this.rest_count <= 0                                    }, // 全問問いた？
    current_exist_p()      { return !!this.articles[this.current_index]                     }, // 現在の問題が存在する？
    current_article()       { return this.articles[this.current_index]                       }, // 現在の問題
    current_sp_body()      { return this.current_article.init_sfen                           }, // 現在の問題のSFEN
    current_sp_viewpoint() { return this.sfen_parse(this.current_sp_body).base_location.key }, // 現在の問題のSFENの視点
  },
}
