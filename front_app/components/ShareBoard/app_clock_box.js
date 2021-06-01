import { IntervalRunner } from '@/components/models/interval_runner.js'
import { ClockBox     } from "@/components/models/clock_box/clock_box.js"
import { CcRuleInfo     } from "@/components/models/cc_rule_info.js"
import { Location       } from "shogi-player/components/models/location.js"

import ClockBoxModal from "./ClockBoxModal.vue"
import TimeLimitModal  from "./TimeLimitModal.vue"

const BYOYOMI_TALK_PITCH = 1.65 // 秒読みは次の発声を予測できるのもあって普通よりも速く読ませる

export const app_clock_box = {
  data() {
    return {
      clock_box: null,
      cc_params: null,
    }
  },

  mounted() {
    this.tl_add("clock_box", "mounted")

    this.cc_params_load()
    this.cc_setup_by_url_params()

    if (this.development_p && false) {
      this.cc_params = { initial_main_min: 60, initial_read_sec: 15, initial_extra_sec: 10, every_plus: 5 }
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    }

    if (this.$route.query["clock_box.play_handle"] === "true") {
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    }
  },

  beforeDestroy() {
    this.cc_destroy()
  },

  methods: {
    cc_setup_by_url_params() {
      ["initial_main_min", "initial_read_sec", "initial_extra_sec", "every_plus"].forEach(key => {
        const argv = this.$route.query[`clock_box.${key}`]
        if (this.present_p(argv)) {
          const value = parseInt(argv)
          this.$set(this.cc_params, key, value)
        }
      })
    },

    cc_create_unless_exist() {
      if (!this.clock_box) {
        this.cc_create()
      }
    },
    cc_create() {
      this.cc_destroy()
      this.clock_box = new ClockBox({
        turn: this.current_location.code, // this.current_sfen を元にした現在の手番
        clock_switch_hook: () => {
          // this.sound_play("click")
        },
        time_zero_callback: e => {
          this.sound_play("lose")
          this.toast_ok("時間切れ")
          this.ac_log("対局時計", "時間切れ")
          this.time_limit_modal_handle()
          // this.$buefy.dialog.alert({
          //   message: "時間切れ",
          //   onConfirm: () => { this.cc_stop_handle() },
          // })
        },
        second_decriment_hook: (single_clock, key, t, m, s) => {
          if (1 <= m && m <= 10) {
            if (s === 0) {
              this.cc_byoyomi(`${m}分`)
            }
          }
          if (t === 10 || t === 20 || t === 30) {
            this.cc_byoyomi(`${t}秒`)
          }
          if (t <= 9) {
            this.cc_byoyomi(t)
          }
        },
      })
    },

    cc_byoyomi(s) {
      this.talk(s, {rate: BYOYOMI_TALK_PITCH})
    },

    cc_destroy() {
      if (this.clock_box) {
        this.clock_box.timer_stop()
        this.clock_box = null
      }
    },

    cc_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: ClockBoxModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
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
      //         <li>同じ合言葉を設定した人とリアルタイムに部屋を共有できます</li>
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
      this.clock_box.resume_handle()
      this.sound_stop_all()
    },
    cc_pause_handle() {
      if (this.clock_box.running_p) {
        // this.sound_stop_all()
        // this.sound_play("click")
        this.clock_box.pause_handle()

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
      if (this.clock_box.running_p) {
        // this.sound_stop_all()
        // this.sound_play("click")
        this.clock_box.stop_handle()
      }
    },
    cc_play_handle() {
      if (this.clock_box.running_p) {
      } else {
        // this.sound_play("start")
        // this.ga_click("対局時計●")
        this.clock_box.play_handle()
      }
    },
    // 指した直後に片方の時計のボタンを押す
    // cc_switch_handle(player_location) {
    //   if (this.clock_box.running_p) {
    //     this.clock_box.tap_on(player_location)
    //   }
    // },
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
          this.sound_stop_all()
          this.sound_play("click")
          this.clock_box.copy_1p_to_2p()
          this.talk("コピーしました")
        },
        onCancel: () => {
          this.sound_stop_all()
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

    // cc_params を clock_box に適用する
    // このタイミングで cc_params を localStorage に保存する
    cc_params_apply() {
      const params = {
        initial_main_sec:  this.cc_params.initial_main_min * 60,
        initial_read_sec:  this.cc_params.initial_read_sec,
        initial_extra_sec: this.cc_params.initial_extra_sec,
        every_plus:        this.cc_params.every_plus,
      }
      this.clock_box.rule_set_all(params)
      this.cc_params_save()
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
          if (e.read_sec >= 1) {
            if (e.read_sec <= 10) {
              container_class.push("read_sec_10")
            } else if (e.read_sec <= 20) {
              container_class.push("read_sec_20")
            } else {
              container_class.push("read_sec_60")
            }
          }
        }
        if (e.read_sec === 0) {
          if (e.initial_extra_sec >= 1) {
            if (e.extra_sec >= 1) {
              if (e.extra_sec <= 10) {
                container_class.push("extra_sec_10")
              } else if (e.extra_sec <= 20) {
                container_class.push("extra_sec_20")
              } else {
                container_class.push("extra_sec_60")
              }
            }
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
    clock_box_share(message) {
      this.__assert__(message != null, "message != null")
      // if (message) {
      //   this.toast_ok(message)
      // }
      const params = {}
      params.cc_params = this.cc_params
      params.message = message
      if (this.clock_box) {
        params.clock_box_attributes = this.clock_box.attributes
      }
      this.ac_room_perform("clock_box_share", params) // --> app/channels/share_board/room_channel.rb
    },
    clock_box_share_broadcasted(params) {
      this.debug_alert("時計同期")
      if (this.received_from_self(params)) {
      } else {
        if (params.clock_box_attributes) {
          this.cc_create_unless_exist()                               // 時計がなければ作って
          this.clock_box.attributes = params.clock_box_attributes // 内部状態を同じにする
          this.cc_params = {...params.cc_params}                      // モーダルのパラメータを同じにする
        } else {
          this.cc_destroy()     // 時計を捨てたことを同期
        }
      }
      if (params.message) {
        const attrs = params.clock_box_attributes
        if (attrs) {
          if (this.first_play_trigger_p(attrs)) { // PLAYの初回なら
            // 開始時の処理
            this.sp_viewpoint_set_by_self_location()               // 自分の場所を調べて正面をその視点にする
            if (this.current_turn_self_p) {       // 自分が手番なら
              // this.tn_notify()                 // 牛
            }
            this.sound_play("rooster")
          }
        }

        // 誰が操作したかを通知
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が時計を${params.message}`, {onend: () => {
          if (attrs) {
            // その後でPLAYの初回なら誰か初手を指すかしゃべる(全員)
            if (this.first_play_trigger_p(attrs)) {
              this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
            }
          }
        }})
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 時間切れ
    time_limit_modal_handle() {
      // this.sidebar_p = false
      // this.sound_play("click")
      this.$buefy.modal.open({
        component: TimeLimitModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: { base: this.base },
        onCancel: () => this.sound_play("click"),
      })
    },

    // private

    first_play_trigger_p(attrs) {
      return attrs.play_count === 1 && attrs.pause_count === 0 && attrs.resume_count === 0
    },
  },
  computed: {
    CcRuleInfo() { return CcRuleInfo },

    // return {
    //   black: { name: "先手", time: this.clock_box.single_clocks[0].to_time_format },
    //   white: { name: "後手", time: this.clock_box.single_clocks[1].to_time_format },
    // }
    sp_player_info() {
      if (this.clock_box) {
        return Location.values.reduce((a, e, i) => {
          return {
            ...a,
            [e.key]: {
              ...this.cc_player_info(this.clock_box.single_clocks[i]),
            },
          }
        }, {})
      }
    },
  },
}
