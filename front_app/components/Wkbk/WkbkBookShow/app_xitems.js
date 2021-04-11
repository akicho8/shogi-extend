import { Location   } from "shogi-player/components/models/location.js"
import { SfenFliper } from 'shogi-player/components/models/sfen_fliper.js'

export const app_xitems = {
  data() {
    return {
      current_index: null,  // 問題インデックス
      answer_tab_index: 0,  // 解答タブ
      // saved_xitems: null, // 最初の状態を xitems を保存しておく
      description_open_p: null,
    }
  },

  methods: {
    play_start() {
      if (!this.g_current_user) {
        this.sound_play("click")
        this.sns_login_required()
        return
      }

      this.sound_play("start")
      this.mode_set("running")

      // 範囲外なら0に戻す
      if (!this.current_xitem) {
        this.current_index = 0
      }

      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p()
      this.re_ox_start()
      if (this.current_xitem) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    next_handle(answer_kind_info) {
      this.re_ox_apply(answer_kind_info)
      this.next_process()
    },

    skip_handle() {
      this.sound_play("click")
      this.next_process()
    },

    previous_handle() {
      this.sound_play("click")
      this.next_process(-1)
    },

    next_process(sign = 1) {
      this.current_index += sign
      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p()
      if (this.current_xitem) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    goal_check() {
      this.__assert__(!this.current_xitem)
      this.mode_set("standby")
      this.sound_play("win")
      this.re_ox_stop()
    },

    play_mode_advanced_moves_set(moves) {
      if (this.soldier_hflip_info.key === "flip_on") {
        moves = SfenFliper.moves_str_flip_h_from_moves_str(moves.join(" ")).split(/\s+/)
      }
      if (this.current_article.moves_valid_p(moves)) {
        if (this.correct_behavior_info.key === this.CorrectBehaviorInfo.fetch("go_to_next").key) {
          this.next_handle(this.AnswerKindInfo.fetch("correct"))
        } else {
          this.toast_ok("正解")
          this.sound_play("o")
        }
      }
    },

    description_open_handle() {
      this.sound_play("click")
      this.description_open_p = !this.description_open_p
    },
  },

  computed: {
    xitems()          { return this.book.xitems                    }, // 問題配列
    rest_count()      { return this.max_count - this.current_index }, // 残り問題数
    max_count()       { return this.xitems.length                  }, // 問題数
    goal_p()          { return this.rest_count <= 0                }, // 全問問いた？
    current_exist_p() { return !!this.xitems[this.current_index]   }, // 現在の問題が存在する？
    current_xitem()   { return this.xitems[this.current_index]     }, // 現在の問題
    current_article() { return this.current_xitem.article          }, // 現在の問題のマスター
    current_article_edit_p() { return this.owner_p                 }, // この問題を編集できるのはこの問題集のオーナーとする

    current_index_human: {
      get()  { return this.current_index + 1 },
      set(v) { this.current_index = v - 1    },
    },
  },
}
