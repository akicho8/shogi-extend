import { IntervalRunner } from '@/components/models/IntervalRunner.js'
import { ChessClock     } from "@/components/models/ChessClock.js"
import { CcRuleInfo       } from "@/components/models/cc_rule_info.js"
import { Location } from "shogi-player/components/models/location.js"
import ChessClockModal from "./ChessClockModal.vue"

export const app_chess_clock = {
  data() {
    return {
      chess_clock: null,
      cc_params: null,
    }
  },

  created() {
    this.cc_params = { initial_main_min: 0, initial_read_sec: 0, initial_extra_sec: 0, every_plus: 0 }

    // // 初期値
    // this.cc_params_apply({initial_main_sec: 60*5, initial_read_sec:0, initial_extra_sec: 0, every_plus: 5})
    //
    // if (this.development_p) {
    //   this.cc_params_apply({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 7文字
    //   this.cc_params_apply({initial_main_sec: 60*30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 5文字
    //   this.cc_params_apply({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0}) // 2行 7文字
    //   this.cc_params_apply({initial_main_sec: 60*60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60}) // 3行 7文字
    // }
  },

  mounted() {
    if (this.development_p) {
      this.cc_params = { initial_main_min: 60, initial_read_sec: 15, initial_extra_sec: 10, every_plus: 0 }
      this.cc_create()
      this.cc_params_apply()
      this.chess_clock.play_handle()
    }
  },

  beforeDestroy() {
    this.cc_destroy()
  },

  methods: {
    cc_create_unless_exist() {
      if (!this.chess_clock) {
        this.cc_create()
      }
    },
    cc_create() {
      this.cc_destroy()
      this.chess_clock = new ChessClock({
        turn: 0,
        clock_switch_hook: () => {
          // this.sound_play("click")
        },
        time_zero_callback: e => {
          this.sound_play("lose")
          this.talk("時間切れ")
          // this.$buefy.dialog.alert({
          //   message: "時間切れ",
          //   onConfirm: () => { this.cc_stop_handle() },
          // })
        },
        second_decriment_hook: (single_clock, key, t, m, s) => {
          if (1 <= m && m <= 10) {
            if (s === 0) {
              this.talk(`${m}分`)
            }
          }
          if (t === 10 || t === 20 || t === 30) {
            this.talk(`${t}秒`)
          }
          if (t <= 9) {
            this.talk(t)
          }
        },
      })
    },

    cc_destroy() {
      if (this.chess_clock) {
        this.chess_clock.timer_stop()
        this.chess_clock = null
      }
    },

    cc_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      // 視点設定変更
      this.$buefy.modal.open({
        component: ChessClockModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: false,
        props: {
          base: this.base,
        },
        // onCancel: () => this.sound_play("click"),
        // events: {
        //   "update:abstract_viewpoint": v => {
        //     this.abstract_viewpoint = v
        //   }
        // },
      })

      // this.$buefy.dialog.prompt({
      //   title: "リアルタイム共有",
      //   size: "is-small",
      //   message: `
      //     <div class="content">
      //       <ul>
      //         <li>同じ合言葉を設定した人とリアルタイムに盤を共有できます</li>
      //         <li>合言葉を設定したら同じ合言葉を相手に伝えてください</li>
      //         <li>合言葉はURLにも付加するのでURLを伝えてもかまいません</li>
      //       </ul>
      //     </div>`,
      //   confirmText: "設定",
      //   cancelText: "キャンセル",
      //   inputAttrs: { type: "text", value: this.room_code, required: false },
      //   onCancel: () => this.sound_play("click"),
      //   onConfirm: value => {
      //     this.sound_play("click")
      //     this.room_code_set(value)
      //   },
      // })
    },

    cc_resume_handle() {
      // this.sound_play("click")
      this.chess_clock.resume_handle()
      this.talk_stop()
    },
    cc_pause_handle() {
      if (this.chess_clock.running_p) {
        // this.talk_stop()
        // this.sound_play("click")
        this.chess_clock.pause_handle()

        if (false) {
          this.$buefy.dialog.confirm({
            title: "ポーズ中",
            message: `終了しますか？`,
            confirmText: "終了",
            cancelText: "再開",
            type: "is-danger",
            hasIcon: false,
            trapFocus: true,
            focusOn: "cancel",
            onCancel:  () => this.cc_resume_handle(),
            onConfirm: () => this.cc_stop_handle(),
          })
        }
      }
    },
    cc_stop_handle() {
      if (this.chess_clock.running_p) {
        // this.talk_stop()
        // this.sound_play("click")
        this.chess_clock.stop_handle()
      }
    },
    cc_play_handle() {
      if (this.chess_clock.running_p) {
      } else {
        // this.sound_play("start")
        // this.ga_click("対局時計●")
        this.chess_clock.play_handle()
      }
    },
    cc_switch_handle(e) {
      this.__assert__(e, "e")
      if (this.chess_clock.running_p) {
        e.simple_switch_handle()
      } else {
        e.tap_and_auto_start_handle()
      }
    },
    cc_copy_handle() {
      this.sound_play("click")
      this.talk("左の設定を右にコピーしますか？")

      this.$buefy.dialog.confirm({
        title: "コピー",
        message: `左の設定を右にコピーしますか？`,
        confirmText: "コピーする",
        cancelText: "キャンセル",
        // type: "is-danger",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => {
          this.talk_stop()
          this.sound_play("click")
          this.chess_clock.copy_1p_to_2p()
          this.talk("コピーしました")
        },
        onCancel: () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })
    },
    cc_dropdown_active_change(on) {
      if (on) {
        this.sound_play("click")
      } else {
        this.sound_play("click")
      }
    },

    cc_params_apply() {
      const params = {
        initial_main_sec:  this.cc_params.initial_main_min * 60,
        initial_read_sec:  this.cc_params.initial_read_sec,
        initial_extra_sec: this.cc_params.initial_extra_sec,
        every_plus:        this.cc_params.every_plus,
      }
      this.chess_clock.rule_set_all(params)
    },

    cc_params_set_by_cc_rule_key(cc_rule_key) {
      this.cc_params = {...CcRuleInfo.fetch(cc_rule_key).cc_params}
    },

    // shogi-player に渡す時間のHTMLを作る
    cc_player_info(e) {
      let o = []
      if (e.initial_main_sec >= 1 || e.every_plus >= 1) {
        o.push(`<div class="second main_sec">${e.to_time_format}</div>`)
      }
      if (e.initial_read_sec >= 1) {
        o.push(`<div class="second read_sec">${e.read_sec}</div>`)
      }
      if (e.initial_extra_sec >= 1) {
        o.push(`<div class="second extra_sec">${e.extra_sec}</div>`)
      }
      const values = o.join("")

      const container_class = [...e.dom_class]
      if (e.main_sec === 0) {
        if (e.initial_read_sec >= 1) {
          if (e.read_sec <= 10) {
            container_class.push("read_sec_10")
          } else if (e.read_sec <= 30) {
            container_class.push("read_sec_30")
          }
        }
      }
      return {
        name: "",
        time: values,
        class: container_class,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 時計の状態をすべて共有する
    chess_clock_share() {
      const params = {}
      params.cc_params = this.cc_params
      if (this.chess_clock) {
        params.chess_clock_attributes = this.chess_clock.attributes
      }
      this.ac_room_perform("chess_clock_share", params) // --> app/channels/share_board/room_channel.rb
    },
    chess_clock_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        if (params.chess_clock_attributes) {
          this.cc_create_unless_exist()                               // 時計がなければ作って
          this.chess_clock.attributes = params.chess_clock_attributes // 内部状態を同じにする
          this.cc_params = {...params.cc_params}                      // モーダルのパラメータを同じにする
        } else {
          this.cc_destroy()
        }
      }
    },

  },
  computed: {
    CcRuleInfo() { return CcRuleInfo },

    // return {
    //   black: { name: "先手", time: this.chess_clock.single_clocks[0].to_time_format },
    //   white: { name: "後手", time: this.chess_clock.single_clocks[1].to_time_format },
    // }
    sp_player_info() {
      if (this.chess_clock) {
        return Location.values.reduce((a, e, i) => {
          return {
            ...a,
            [e.key]: {
              ...this.cc_player_info(this.chess_clock.single_clocks[i]),
            },
          }
        }, {})
      }
    },
  },
}
