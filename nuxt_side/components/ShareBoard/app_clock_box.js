import { IntervalRunner } from '@/components/models/interval_runner.js'
import { ClockBox       } from "@/components/models/clock_box/clock_box.js"
import { CcRuleInfo     } from "@/components/models/cc_rule_info.js"
import { Location       } from "shogi-player/components/models/location.js"

import ClockBoxModal  from "./ClockBoxModal.vue"

const BYOYOMI_TALK_PITCH = 1.65          // 秒読みは次の発声を予測できるのもあって普通よりも速く読ませる

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
          this.cc_time_zero_callback()
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
        canCancel: ["escape", "outside"],
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },

    cc_resume_handle() {
      this.clock_box.resume_handle()
      this.sound_stop_all()
    },
    cc_pause_handle() {
      if (this.clock_box.running_p) {
        this.clock_box.pause_handle()
      }
    },
    cc_stop_handle() {
      if (this.clock_box.running_p) {
        this.clock_box.stop_handle()
      }
    },
    cc_play_handle() {
      if (this.clock_box.running_p) {
      } else {
        this.clock_box.play_handle()
      }
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

    // 時計の状態をすべて共有するためのパラメータを作る
    clock_box_share_params_build(behaviour = null) {
      const params = {}
      params.cc_params = this.cc_params
      if (behaviour) {
        params.behaviour = behaviour
        params.room_code_except_url = this.room_code_except_url
      } else {
        // 静かに同期するとき
      }
      if (this.clock_box) {
        params.clock_box_attributes = this.clock_box.attributes
      }
      return params
    },
    // 時計の状態をすべて共有する
    clock_box_share(behaviour = null) {
      this.ac_room_perform("clock_box_share", this.clock_box_share_params_build(behaviour)) // --> app/channels/share_board/room_channel.rb
    },
    clock_box_share_broadcasted(params) {
      this.tl_alert("時計同期")
      if (this.received_from_self(params)) {
      } else {
        if (params.clock_box_attributes) {
          this.cc_create_unless_exist()                           // 時計がなければ作って
          this.clock_box.attributes = params.clock_box_attributes // 内部状態を同じにする
          this.cc_params = {...params.cc_params}                  // モーダルのパラメータを同じにする
        } else {
          this.cc_destroy()     // 時計を捨てたことを同期
        }
      }
      if (params.behaviour) {
        this.cc_action_log_store(params)         // 履歴追加
        this.cc_location_change_and_call(params) // ニワトリ

        if (params.behaviour === "時間切れ") {
          this.time_limit_modal_handle_if_not_exist()
        } else {
          // 誰が操作したかを通知
          this.toast_ok(`${this.user_call_name(params.from_user_name)}が時計を${params.behaviour}しました`, {onend: () => {
            // その後でPLAYの初回なら誰か初手を指すかしゃべる(全員)
            if (this.first_play_trigger_p(params)) {
              if (this.current_turn_user_name) {
                this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
              } else {
                // 順番設定をしていない場合
              }
            }
          }})
        }
      }
    },

    cc_action_log_store(params) {
      this.__assert__(params.behaviour, "params.behaviour")

      params = {
        ...params,
        label: `時計${params.behaviour}`,
        clock_box_attributes: null, // 容量が大きいので空にしておく
        room_code_except_url: null, // 絶対に使わないので消しておく
      }

      this.al_add(params)
    },

    cc_location_change_and_call(params) {
      if (this.first_play_trigger_p(params)) { // PLAYの初回なら
        // 開始時の処理
        this.sp_viewpoint_set_by_self_location()               // 自分の場所を調べて正面をその視点にする
        if (this.current_turn_self_p) {       // 自分が手番なら
          // this.tn_notify()                 // 牛
          this.tl_alert(`${this.user_name}から開始を${this.user_name}だけに通知`)
        }
        this.sound_play("rooster")
      }
    },

    // private

    // 最初の PLAY か？
    first_play_trigger_p(params) {
      if (true) {
        return params.behaviour === "開始"
      } else {
        if (params.behaviour === "開始") {
          const attrs = params.clock_box_attributes
          if (attrs) {
            return attrs.play_count === 1 && attrs.pause_count === 0 && attrs.resume_count === 0
          }
        }
      }
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
