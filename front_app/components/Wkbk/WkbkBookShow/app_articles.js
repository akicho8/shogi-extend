export const app_articles = {
  data() {
    return {
      current_index: null, // 問題インデックス
      answer_tab_index: 0, // 解答タブ
    }
  },

  mounted() {
    this.ga_click("問題集を解く")
  },

  methods: {
    play_start() {
      this.sound_play("start")
      this.play_start_process()
    },

    play_start_process() {
      this.mode_set("running")
      this.current_index = 0
      this.answer_tab_index = 0
      this.ox_start()
      if (this.current_article) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    next_handle(o) {
      this.ox_apply(o)
      this.current_index += 1
      this.answer_tab_index = 0
      if (this.current_article) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    play_restart() {
      this.play_start()
    },

    goal_check() {
      this.__assert__(!this.current_article)
      this.mode_set("standby")
      this.sound_play("win")
      this.ox_stop()
    },

    play_mode_advanced_moves_set(moves) {
      if (this.current_article.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
      }
    },
  },

  computed: {
    articles()             { return this.book.articles                  }, // 問題配列
    rest_count()           { return this.max_count - this.current_index }, // 残り問題数
    max_count()            { return this.articles.length                }, // 問題数
    goal_p()               { return this.rest_count <= 0                }, // 全問問いた？
    current_exist_p()      { return !!this.articles[this.current_index] }, // 現在の問題が存在する？
    current_article()      { return this.articles[this.current_index]   }, // 現在の問題
    current_sp_body()      { return this.current_article.init_sfen      }, // 現在の問題のSFEN
    current_sp_viewpoint() { return this.current_article.viewpoint      }, // 現在の問題の視点
    // current_sp_viewpoint() { return this.sfen_parse(this.current_sp_body).base_location.key }, // 現在の問題のSFENの視点
  },
}
