import { IntervalRunner } from '@/components/models/IntervalRunner.js'
import { ChessClock     } from "@/components/models/ChessClock.js"
import { CcRuleInfo       } from "@/components/models/cc_rule_info.js"
import { Location } from "shogi-player/components/models/location.js"
import ChessClockSettingModal from "./ChessClockSettingModal.vue"

export const app_chess_clock = {
  data() {
    return {
      chess_clock: null,
      cc_rule_info_key: CcRuleInfo.values[0].key,

      cc_params: {
        initial_main_min: 5,
        initial_read_sec: 0,
        initial_extra_sec: 0,
        every_plus: 5,
      },
    }
  },

  created() {
    this.chess_clock = new ChessClock({
      turn: 0,
      clock_switch_hook: () => {
        this.sound_play("click")
      },
      time_zero_callback: e => {
        this.sound_play("lose")
        this.say("時間切れ")
        this.$buefy.dialog.alert({
          message: "時間切れ",
          onConfirm: () => { this.cc_stop_handle() },
        })
      },
      second_decriment_hook: (single_clock, key, t, m, s) => {

        this.chess_clock.single_clocks[membership.position].to_time_format

        if (1 <= m && m <= 10) {
          if (s === 0) {
            this.say(`${m}分`)
          }
        }
        if (t === 10 || t === 20 || t === 30) {
          this.say(`${t}秒`)
        }
        if (t <= 5) {
          this.say(`${t}`)
        }
        if (t <= 6 && false) {
          const index = single_clock.index
          setTimeout(() => {
            if (index === single_clock.base.current_index) {
              this.say(`${t - 1}`)
            }
          }, 1000 * 0.75)
        }
      },
    })

    // // 初期値
    // this.cc_rule_set({initial_main_sec: 60*5, initial_read_sec:0, initial_extra_sec: 0, every_plus: 5})
    //
    // if (this.development_p) {
    //   this.cc_rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 7文字
    //   this.cc_rule_set({initial_main_sec: 60*30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 5文字
    //   this.cc_rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0}) // 2行 7文字
    //   this.cc_rule_set({initial_main_sec: 60*60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60}) // 3行 7文字
    // }
  },

  mounted() {
  },

  beforeDestroy() {
    if (this.chess_clock) {
      this.chess_clock.timer_stop()
    }
  },

  methods: {
    cc_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      // 視点設定変更
      this.$buefy.modal.open({
        component: ChessClockSettingModal,
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
      this.sound_play("click")
      this.chess_clock.pause_off()
      this.talk_stop()
    },
    cc_pause_handle() {
      if (this.chess_clock.running_p) {
        this.talk_stop()
        this.sound_play("click")
        this.chess_clock.pause_on()

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
        this.talk_stop()
        this.sound_play("click")
        this.chess_clock.stop_button_handle()
      }
    },
    cc_play_handle() {
      if (this.chess_clock.running_p) {
      } else {
        // this.sound_play("start")
        this.ga_click("対局時計●")
        this.chess_clock.play_button_handle()
      }
    },
    cc_switch_handle(e) {
      if (this.chess_clock.running_p) {
        e.simple_switch_handle()
      } else {
        e.tap_and_auto_start_handle()
      }
    },
    cc_copy_handle() {
      this.sound_play("click")
      this.say("左の設定を右にコピーしますか？")

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
          this.say("コピーしました")
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
    cc_rule_set(v) {
      const params = {
        initial_main_sec:  v.initial_main_min * 60,
        initial_read_sec:  v.initial_read_sec,
        initial_extra_sec: v.initial_extra_sec,
        every_plus:        v.every_plus,
      }
      this.chess_clock.rule_set_all(params)
    },
    cc_rule_set2(cc_params) {
      this.cc_params = cc_params
    },
    cc_rule_set3(cc_rule_info_key) {
      this.cc_params = {...CcRuleInfo.fetch(cc_rule_info_key).cc_params}
    },
  },
  computed: {
    CcRuleInfo() { return CcRuleInfo },

    // return {
    //   black: { name: "先手", time: this.chess_clock.single_clocks[0].to_time_format },
    //   white: { name: "後手", time: this.chess_clock.single_clocks[1].to_time_format },
    // }
    sp_player_info() {
      return Location.values.reduce((a, e, i) => {
        return {
          ...a,
          [e.key]: {
            name: null,
            time: this.chess_clock.single_clocks[i].to_time_format,
          },
        }
      }, {})
    },
  },
}
