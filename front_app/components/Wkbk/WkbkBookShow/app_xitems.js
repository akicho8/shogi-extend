export const app_xitems = {
  data() {
    return {
      current_index: null,  // 問題インデックス
      answer_tab_index: 0,  // 解答タブ
      saved_xitems: null, // 最初の状態を xitems を保存しておく
      description_open_p: null,
    }
  },

  methods: {
    play_start() {
      this.sound_play("start")
      this.play_start_process()
    },

    play_start_process() {
      this.mode_set("running")
      // this.current_index = 0
      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p()
      this.ox_start()
      if (this.current_xitem) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    next_handle(answer_kind_info) {
      this.ox_apply(answer_kind_info)
      this.current_index += 1
      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p()
      if (this.current_xitem) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    play_restart() {
      this.play_start()
    },

    goal_check() {
      this.__assert__(!this.current_xitem)
      this.mode_set("standby")
      this.sound_play("win")
      this.ox_stop()
    },

    play_mode_advanced_moves_set(moves) {
      if (this.current_xitem.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
      }
    },

    description_open_handle() {
      this.sound_play("click")
      this.description_open_p = !this.description_open_p
    },
  },

  computed: {
    xitems()             { return this.book.xitems                  }, // 問題配列
    rest_count()           { return this.max_count - this.current_index }, // 残り問題数
    max_count()            { return this.xitems.length                }, // 問題数
    goal_p()               { return this.rest_count <= 0                }, // 全問問いた？
    current_exist_p()      { return !!this.xitems[this.current_index] }, // 現在の問題が存在する？
    current_xitem()         { return this.xitems[this.current_index]   }, // 現在の問題
    current_sp_body()      { return this.current_xitem.init_sfen      }, // 現在の問題のSFEN
    current_sp_viewpoint() { return this.current_xitem.viewpoint      }, // 現在の問題の視点
    // current_sp_viewpoint() { return this.sfen_parse(this.current_sp_body).base_location.key }, // 現在の問題のSFENの視点

    current_index_human: {
      get()  { return this.current_index + 1 },
      set(v) { this.current_index = v - 1    },
    },
  },
}
