import { Location   } from "shogi-player/components/models/location.js"
import { MoveHash } from 'shogi-player/components/models/move_hash.js'
import { NextHandFinder } from "./next_hand_finder.js"

const NEXT_HAND_DELAY = 0 // 0超は危険。次の問題に入ったあとで前の問題の応手が発動してしまう場合がある

export const mod_xitems = {
  data() {
    return {
      current_index: null,  // 問題インデックス
      answer_tab_index: 0,  // 解答タブ
      // saved_xitems: null, // 最初の状態を xitems を保存しておく
      description_open_p: null,
      // current_sfen: null,
    }
  },

  methods: {
    play_start() {
      this.sfx_play("start")
      this.app_log({emoji: ":問題集:", subject: "将棋ドリル問題集", body: `[START] ${this.book.title}`})
      this.mode_set("running")

      // 範囲外なら0に戻す
      if (!this.current_xitem) {
        this.current_index = 0
      }

      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p
      this.re_ox_start()
      if (this.current_xitem) {
        // this.current_sfen = this.sfen_flop(this.current_init_sfen)
        // this.current_sfen = "position sfen 4p4/9/9/9/9/9/9/9/4P4 b - 1 moves 5i5h 5a5b"
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
      this.sfx_click()
      this.next_process()
    },

    previous_handle() {
      this.sfx_click()
      this.next_process(-1)
    },

    next_process(sign = 1) {
      this.current_index += sign
      this.answer_tab_index = 0
      this.description_open_p = this.mobile_p
      if (this.current_xitem) {
        this.journal_next_init()
      } else {
        this.goal_check()
      }
    },

    goal_check() {
      this.$GX.assert(!this.current_xitem)
      this.mode_set("standby")
      this.sfx_play("win")
      this.re_ox_stop()
    },

    ev_play_mode_next_moves(moves) {
      if (this.soldier_flop_info.key === "flop_on") {
        moves = MoveHash.line_flop(moves.join(" ")).split(/\s+/)
      }

      let success = null
      if (this.moves_match_info.key === "all") {
        success = this.current_article.moves_valid_p(moves)
      } else {
        success = this.current_article.moves_first_valid_p(moves)
      }

      if (!success) {
        // 不正解または途中
        if (this.auto_move_info.key === "auto_move_on") {
          this.next_hand_auto_move(moves)
        }
      } else {
        // 正解
        if (this.correct_behavior_info.key === "correct_behavior_next") {
          this.next_handle(this.AnswerKindInfo.fetch("correct"))
        } else {
          this.toast_ok("正解")
          this.sfx_play("o")
        }
      }
    },

    // 自分の手番であれば次の手を自動的に指す
    next_hand_auto_move(moves) {
      // this.$GX.delay_block(NEXT_HAND_DELAY, () => {
      const new_moves = new NextHandFinder(this.current_article.list_of_moves, moves).call()
      if (new_moves) {
        const new_sfen = [this.current_article.init_sfen, "moves", ...new_moves].join(" ")
        const floped_sfen = this.sfen_flop(new_sfen)
        this.sp_sfen_set(floped_sfen)
      }
      // })
    },

    description_open_handle() {
      this.sfx_click()
      this.description_open_p = !this.description_open_p
    },

    //////////////////////////////////////////////////////////////////////////////// 命令型APIを直接実行する

    sp_sfen_set(sfen) {
      const r = this.sp_object()
      if (r) {
        r.api_lifted_piece_cancel()
        r.api_sfen_or_kif_set(sfen, {turn: -1})
        r.api_play_mode_setup()
        // r.init_sfen = r.xcontainer.data_source.init_sfen
        // r.moves     = r.xcontainer.data_source.moves
        // // this.xcontainer_setup(this.sp_turn)
        // // if (this.play_p) {
        // //   this.play_mode_setup_from("view")
      }
    },

    // computed 側にすると動かなくなるので注意
    sp_object() {
      return this.$refs?.WkbkBookShowSp?.$refs?.main_sp?.sp_object()
    },
  },

  computed: {
    xitems()                 { return this.book.xitems                               }, // 問題配列
    rest_count()             { return this.max_count - this.current_index            }, // 残り問題数
    max_count()              { return this.xitems.length                             }, // 問題数
    goal_p()                 { return this.rest_count <= 0                           }, // 全問問いた？
    current_exist_p()        { return !!this.xitems[this.current_index]              }, // 現在の問題が存在する？
    current_xitem()          { return this.xitems[this.current_index]                }, // 現在の問題
    current_article()        { return this.current_xitem.article                     }, // 現在の問題のマスター
    current_article_edit_p() { return this.owner_p                                   }, // この問題を編集できるのはこの問題集のオーナーとする
    current_init_sfen()      { return this.sfen_flop(this.current_article.init_sfen) }, // 現在の問題の初期配置

    current_index_human: {
      get()  { return this.current_index + 1 },
      set(v) { this.current_index = v - 1    },
    },
  },
}
