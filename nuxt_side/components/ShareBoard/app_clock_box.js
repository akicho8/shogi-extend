const BYOYOMI_TALK_PITCH = 1.65 // 秒読み発声速度。次の発声に被らないようにする。速くても人間が予測できるので聞き取れる

import { ClockBox       } from "@/components/models/clock_box/clock_box.js"
import { CcRuleInfo     } from "@/components/models/cc_rule_info.js"
import { Location       } from "shogi-player/components/models/location.js"

import _ from "lodash"

import ClockBoxModal  from "./ClockBoxModal.vue"

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
      this.cc_params = [{ initial_main_min: 60, initial_read_sec: 15, initial_extra_sec: 10, every_plus: 5 }]
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    }

    if (this.$route.query.clock_box_play_handle === "true") {
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
        const argv = this.$route.query[`clock_box_${key}`]
        if (this.present_p(argv)) {
          const value = parseInt(argv)
          this.$set(this.cc_params[0], key, value)
        }
      })
    },

    cc_main_switch_set(v) {
      if (v) {
        this.cc_create()
        this.cc_params_apply() // ONにしたらすぐにパラメータを反映する
        this.clock_box_share({behaviour: "設置"})
      } else {
        this.cc_destroy()
        this.clock_box_share({behaviour: "破棄"})
      }
    },

    // true:時計を個別設定する false:共通
    cc_unique_mode_set(value) {
      const one = this.cc_params[0]
      let av = null
      if (value) {
        av = [_.cloneDeep(one), _.cloneDeep(one)] // _.cloneDeep([one, one]) では uniq.size == 1 になるので注意
      } else {
        av = [_.cloneDeep(one)]
      }
      this.cc_params = av
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
          // this.sound_play_click()
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
      this.sound_play_click()
      this.modal_card_open({
        component: ClockBoxModal,
        props: { base: this.base },
      })
    },

    cc_resume_handle() {
      this.clock_box.resume_handle()
    },
    cc_pause_handle() {
      if (this.clock_box.pause_or_play_p) {
        this.clock_box.pause_handle()
      }
    },
    cc_stop_handle() {
      if (this.clock_box.pause_or_play_p) {
        this.clock_box.stop_handle()
      }
    },
    // 対局時計が動いている場合は停止する
    cc_stop_share_handle() {
      if (this.cc_play_p) {
        this.cc_stop_handle()
        this.clock_box_share({behaviour: "停止", toast_only: true})
      }
    },
    cc_play_handle() {
      if (this.clock_box.pause_or_play_p) {
      } else {
        this.clock_box.play_handle()
      }
    },
    cc_dropdown_active_change(on) {
      if (on) {
        this.sound_play_click()
      } else {
        this.sound_play_click()
      }
    },

    // cc_params を clock_box に適用する
    // このタイミングで cc_params を localStorage に保存する
    cc_params_apply() {
      this.__assert__(_.isArray(this.cc_params), "_.isArray(this.cc_params)")
      this.__assert__(this.cc_params.length >= 1, "this.cc_params.length >= 1")
      const ary = this.clock_box.single_clocks.map((e, i) => this.cc_params_one_to_clock_box_params(this.cc_params[i] || this.cc_params[0]))
      this.clock_box.rule_set_all_by_ary(ary)
      this.cc_params_save()
    },

    // 共有将棋盤では扱いやすいように持ち時間は分にしている
    // 一方、時計は秒で管理しているため秒単位に変換する
    cc_params_one_to_clock_box_params(params) {
      return {
        initial_main_sec:  params.initial_main_min * 60,
        initial_read_sec:  params.initial_read_sec,
        initial_extra_sec: params.initial_extra_sec,
        every_plus:        params.every_plus,
      }
    },

    cc_params_set_by_cc_rule_key(cc_rule_key) {
      this.cc_params = CcRuleInfo.fetch(cc_rule_key).cc_params
    },

    // shogi-player に渡す名前
    sp_player_name_for(location) {
      // return "０１２３４５６７８９"
      if (location.key === this.current_location.key) {
        return this.current_turn_user_name
      } else {
        return this.next_turn_user_name
      }
    },

    // shogi-player に渡す時間のHTMLを作る
    cc_player_info(location) {
      if (this.clock_box == null) {
        return {}
      }

      const e = this.clock_box.single_clocks[location.code]
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
        time: values,
        class: container_class,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 時計の状態をすべて共有するためのパラメータを作る
    clock_box_share_params_factory(params = {}) {
      params = {
        toast_only: false,
        ...params,
        ...this.current_xclock,
      }
      if (params.behaviour) {
        params.room_code_except_url = this.room_code_except_url // 棋譜再現URLをログに出すため
      }
      return params
    },
    // 時計の状態をすべて共有する
    clock_box_share(params) {
      params = this.clock_box_share_params_factory(params)
      this.ac_room_perform("clock_box_share", params) // --> app/channels/share_board/room_channel.rb
    },
    clock_box_share_broadcasted(params) {
      this.tl_add("時計受信", `${params.from_user_name} -> ${this.user_name}`, params)
      this.tl_alert("時計同期")
      if (this.received_from_self(params)) {
      } else {
        this.receive_xclock(params)
      }
      this.cc_action_log_store(params)         // 履歴追加
      this.cc_location_change_and_call(params) // ニワトリ
      if (false) {
      } else if (params.behaviour === "時間切れ") {
        this.time_limit_modal_handle_if_not_exist()
      } else if (params.behaviour === "開始") {
        this.toast_ok(this.cc_receive_message(params), {
          onend: () => {
            // その後でPLAYの初回なら誰か初手を指すかしゃべる(全員)
            if (this.current_turn_user_name) {
              this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
            } else {
              // 順番設定をしていない場合
            }
          },
        })
      } else if (params.behaviour) {
        this.toast_ok(this.cc_receive_message(params), {toast_only: params.toast_only})
      } else {
        // 表示も音もない更新
      }
    },
    cc_receive_message(params) {
      return `${this.user_call_name(params.from_user_name)}が時計を${params.behaviour}しました`
    },

    // setup_info_send_broadcasted から呼ばれたときは from_user_name は入っていないので注意
    receive_xclock(params) {
      this.__assert__(this.present_p(params), "this.present_p(params)")
      this.tl_add("時計", `${this.user_name} は時計情報を受信して反映した`, params)
      if (params.clock_box_attributes) {
        this.cc_create_unless_exist()                           // 時計がなければ作って
        this.clock_box.attributes = params.clock_box_attributes // 内部状態を同じにする
        this.cc_params = _.cloneDeep(params.cc_params)          // モーダルのパラメータを同じにする
      } else {
        this.cc_destroy()                                       // 時計を捨てたことを同期
      }
    },

    cc_action_log_store(params) {
      if (params.behaviour) {
        params = {
          ...params,
          label: `時計${params.behaviour}`,
          clock_box_attributes: null, // 容量が大きいので空にしておく
          room_code_except_url: null, // 絶対に使わないので消しておく
        }
        this.al_add(params)
      }
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
      return params.behaviour === "開始"
    },

    cc_play_confirm(params = {}) {
      this.sound_play_click()
      this.talk("ちょっと待って。先に順番設定をしてください")
      this.dialog_confirm({
        title: "ちょっと待って",
        type: "is-warning",
        iconSize: "is-small",
        hasIcon: true,
        message: `
          <div class="content">
            <p>先に<b>順番設定</b>をしてください</p>
            <p class="mb-0 is-size-7">設定すると有効になるもの:</p>
            <ol class="mt-2">
              <li>手番を知らせる</li>
              <li>手番の人だけ指せる</li>
              <li>指し手の伝達を保証する ← <span class="has-text-danger">重要</span></li>
            </ol>
          </div>
        `,
        confirmText: "無視して開始する",
        focusOn: "cancel",
        ...params,
      })
    },

    // 順番設定で更新を押したあとで呼ぶ
    cc_next_message() {
      let message = null
      if (this.clock_box) {
        if (this.clock_box.current_status === "pause") {
          message = "次は時計を再開してください"
        }
        if (this.clock_box.current_status === "stop") {
          message = "次は時計を設定してください"
        }
      } else {
        message = "次は時計を設置してください"
      }
      this.toast_ok(message)
    },

    cc_params_inspect(params) {
      this.__assert__(_.isArray(params), "_.isArray(params)")
      const values = params.map(params => this.CcRuleInfo.cc_params_keys.map(e => params[e]))
      return JSON.stringify(values)
    },

    cc_params_debug(label, params) {
      this.tl_add("CC初期値", `${label}: ${this.cc_params_inspect(params)}`)
    },
  },

  computed: {
    CcRuleInfo()     { return CcRuleInfo                },

    cc_play_p()  { return this.clock_box && this.clock_box.play_p }, // 時計の状態 PLAY

    cc_unique_p()  { return this.cc_params.length == 2                 }, // 個別設定か？
    cc_common_p()  { return this.cc_params.length == 1                 }, // 共通設定か？

    // 共有する時計情報
    current_xclock() {
      const params = {}
      params.cc_params = this.cc_params
      if (this.clock_box) {
        params.clock_box_attributes = this.clock_box.attributes
      }
      return params
    },

    // 順番設定を有効にしてないのに時計を開始しようとしている？
    clock_start_even_though_order_is_not_enabled_p() {
      return this.ac_room && !this.order_enable_p
    },

    // return {
    //   black: { name: "先手", time: this.clock_box.single_clocks[0].to_time_format },
    //   white: { name: "後手", time: this.clock_box.single_clocks[1].to_time_format },
    // }
    sp_player_info() {
      return Location.values.reduce((a, e) => {
        return {
          ...a,
          [e.key]: {
            name: this.sp_player_name_for(e),
            ...this.cc_player_info(e),
          },
        }
      }, {})
    },
  },
}
