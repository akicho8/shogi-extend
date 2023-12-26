const BYOYOMI_TALK_PITCH      = 1.65 // 秒読み発声速度。次の発声に被らないようにする。速くても人間が予測できるので聞き取れる
const CC_INPUT_DEBOUNCE_DELAY = 0.5  // 時計の同期のために操作が終わったと判断する秒数

import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { CcRuleInfo } from "@/components/models/cc_rule_info.js"
import { CcInfo     } from "./cc_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

import ClockBoxModal  from "./ClockBoxModal.vue"

export const mod_clock_box = {
  data() {
    return {
      clock_box: null,
      cc_params: null,
      cc_modal_instance: null,
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

    if (this.$route.query.clock_auto_start === "true") {
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    }
  },

  beforeDestroy() {
    this.cc_modal_close()
    this.cc_destroy()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    cc_modal_shortcut_handle() {
      if (this.cc_modal_instance == null) {
        this.cc_modal_open_handle()
        return true
      }
    },

    cc_modal_open_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.cc_modal_open()
    },

    cc_modal_close_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.cc_modal_close()
    },

    cc_modal_open() {
      this.cc_modal_close()
      this.cc_modal_instance = this.modal_card_open({
        component: ClockBoxModal,
        onCancel: () => {
          this.$sound.play_click()
          this.cc_modal_close()
        },
      })
    },

    cc_modal_close() {
      if (this.cc_modal_instance) {
        this.cc_modal_instance.close()
        this.cc_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    cc_play_by(initial_main_min = 10, initial_read_sec = 30, initial_extra_sec = 0, every_plus = 0) {
      this.cc_params = [
        {
          initial_main_min: initial_main_min,
          initial_read_sec: initial_read_sec,
          initial_extra_sec: initial_extra_sec,
          every_plus: every_plus,
        }
      ]
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    },

    cc_setup_by_url_params() {
      [
        "initial_main_min",
        "initial_read_sec",
        "initial_extra_sec",
        "every_plus",
      ].forEach(column => {
        const key = `clock_box.${column}`
        const value = this.$route.query[key]
        if (Gs.present_p(value)) {
          const iv = parseInt(value)
          this.$set(this.cc_params[0], column, iv)
        }
      })
    },

    cc_main_switch_set(v) {
      if (v) {
        this.cc_create()
        this.cc_params_apply() // ONにしたらすぐにパラメータを反映する
        this.clock_box_share("ck_on")
      } else {
        this.cc_destroy()
        this.clock_box_share("ck_off")
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
        initial_turn: this.current_location.code, // this.current_sfen を元にした現在の手番
        koreyori_fn: context => this.cc_koreyori(context.initial_read_sec),
        time_zero_fn: e => this.cc_time_zero_callback(),
        switched_fn: () => {
          // this.$sound.play_click()
        },
        second_decriment_fn: (single_clock, key, sec, mm, ss) => {
          if (1 <= mm && mm <= 10) {
            if (ss === 0) {
              this.cc_interval_yomi(`${mm}分`)
            }
          }
          if (sec === 10 || sec === 20 || sec === 30) {
            this.cc_interval_yomi(`${sec}秒`)
          }
          if (key === "read_sec") {
            // 秒読みの場合は何回も繰り返されるため(煩くならないように)調整する
            if (sec <= this.cc_byoyomi_start_for_read_sec(single_clock)) {
              this.cc_byoyomi(sec)
            }
          } else {
            // main_sec, extra_sec の場合
            if (sec <= 9) {
              this.cc_byoyomi(sec)
            }
          }
        },
      })

      this.clock_box.speed = this.clock_speed
    },

    // 秒読み10秒設定のとき毎回9から読み上げると騒いので10秒なら5秒から読み上げる
    // 同様に5秒なら3秒からとする
    cc_byoyomi_start_for_read_sec(single_clock) {
      const sec = single_clock.initial_read_sec
      if (sec <= 5) {
        return 3
      }
      if (sec <= 10) {
        return 5
      }
      if (sec <= 15) {
        return 7
      }
      return 9
    },

    // 9〜1 の読み上げ
    cc_byoyomi(t) {
      if (t <= this.byoyomi_mode_info.byoyomi) {
        this.cc_talk(t)
      }
    },

    // "n分" や "30秒" の読み上げ
    cc_interval_yomi(s) {
      if (this.byoyomi_mode_info.interval_yomi) {
        this.cc_talk(s)
      }
    },

    cc_koreyori(sec) {
      this.cc_talk(`これより1手${sec}秒でお願い致します`)
    },

    cc_talk(s, options = {}) {
      options = {
        rate: BYOYOMI_TALK_PITCH,
        volume: this.clock_volume,
        ...options,
      }
      this.talk2(s, options)
    },

    cc_destroy() {
      if (this.clock_box) {
        this.clock_box.timer_stop()
        this.clock_box = null
      }
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
        this.clock_box_share("ck_silent_stop")
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
        this.$sound.play_click()
      } else {
        this.$sound.play_click()
      }
    },

    // cc_params を clock_box に適用する
    // このタイミングで cc_params を localStorage に保存する
    cc_params_apply() {
      this.cc_params_apply_without_save()
      this.cc_params_save()
    },
    cc_params_apply_without_save() {
      Gs.assert(_.isArray(this.cc_params), "_.isArray(this.cc_params)")
      Gs.assert(this.cc_params.length >= 1, "this.cc_params.length >= 1")
      const ary = this.clock_box.single_clocks.map((e, i) => this.cc_params_one_to_clock_box_params(this.cc_params[i] || this.cc_params[0]))
      this.clock_box.rule_set_all_by_ary(ary)
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

    ////////////////////////////////////////////////////////////////////////////////

    // 時計設定時に時計の内容をほぼリアルタイムに同期する
    // @input はクリックイベントのみに反応するので無限ループになることはない
    cc_input_handle(v) {
      this.cc_params_apply_without_save()  // リアルタイムに反映する
      this.cc_input_handle_lazy(v)
    },
    cc_input_handle_lazy: _.debounce(function(v) {
      this.clog(v)
      this.cc_params_save()            // 何度も localStorage に保存すると遅いので操作後にする
      this.clock_box_share("ck_input") // みんなへの同期も操作後にする
    }, 1000 * CC_INPUT_DEBOUNCE_DELAY),

    ////////////////////////////////////////////////////////////////////////////////

    // 時計の状態をすべて共有するためのパラメータを作る
    clock_box_share_params_factory(cc_key, params = {}) {
      const cc_info = CcInfo.fetch(cc_key)
      params = {
        cc_key: cc_info.key,
        talk: true,
        ...params,
        ...this.clock_share_data,
      }
      if (cc_info.with_url) {
        params.current_url = this.current_url // 棋譜再現URLをログに出すため
      }
      return params
    },
    // 時計の状態をすべて共有する
    clock_box_share(cc_key, params = {}) {
      params = this.clock_box_share_params_factory(cc_key, params)
      this.ac_room_perform("clock_box_share", params) // --> app/channels/share_board/room_channel.rb
    },
    clock_box_share_broadcasted(params) {
      const cc_info = CcInfo.fetch(params.cc_key)
      this.tl_add("時計受信", `${params.from_user_name} -> ${this.user_name}`, params)
      this.tl_alert("時計同期")
      if (this.received_from_self(params)) {
      } else {
        this.clock_share_data_receive(params)
      }
      this.__cc_action_log_store(params)         // 履歴追加
      this.__cc_location_change_and_call(params) // 視点変更とニワトリ
      if (cc_info.key === "ck_timeout") {
        this.timeout_modal_handle_if_not_exist()
      } else if (cc_info.key === "ck_start") {
        this.__cc_start_call(params)
      } else if (cc_info.key === "ck_on") {
        this.toast_ok(this.__cc_receive_message(params), {onend: () => {
          if (this.received_from_self(params)) {
            this.toast_ok("時間を設定したら右下のボタンで対局を開始してください", {duration: 1000 * 3})
          }
        }})
      } else if (cc_info.toast_p) {
        this.toast_ok(this.__cc_receive_message(params), {talk: cc_info.with_talk})
      }
      this.cc_timeout_logging(params)
      this.ai_say_case_clock(params)
    },
    __cc_receive_message(params) {
      const cc_info = CcInfo.fetch(params.cc_key)
      return `${this.user_call_name(params.from_user_name)}が${cc_info.receive_message}`
    },
    __cc_start_call(params) {
      this.toast_ok(this.__cc_receive_message(params), {
        onend: () => {
          // その後でPLAYの初回なら誰か初手を指すかしゃべる(全員)
          if (this.current_turn_user_name) {
            this.toast_ok(`${this.user_call_name(this.current_turn_user_name)}から開始してください`)
          } else {
            // 順番設定をしていない場合
          }
        },
      })
    },

    // setup_info_send_broadcasted から呼ばれたときは from_user_name は入っていないので注意
    clock_share_data_receive(params) {
      Gs.assert(Gs.present_p(params), "Gs.present_p(params)")
      this.tl_add("時計", `${this.user_name} は時計情報を受信して反映した`, params)
      if (params.clock_box_attributes == null) {
        this.cc_destroy()                                       // 時計を捨てたことを同期
      } else {
        this.cc_create_unless_exist()                           // 時計がなければ作って
        this.clock_box.attributes = params.clock_box_attributes // 内部状態を同じにする
        this.cc_params = _.cloneDeep(params.cc_params)          // モーダルのパラメータを同じにする
      }
    },

    __cc_action_log_store(params) {
      const cc_info = CcInfo.fetch(params.cc_key)
      if (cc_info.history) {
        params = {
          ...params,
          label: cc_info.label,
          label_type: cc_info.label_type,
          clock_box_attributes: null, // 容量が大きいので空にしておく
          current_url: null, // 絶対に使わないので消しておく
        }
        this.al_add(params)
      }
    },

    __cc_location_change_and_call(params) {
      if (this.first_play_trigger_p(params)) { // PLAYの初回なら
        // 開始時の処理
        // this.sp_viewpoint_set_by_self_location()               // 自分の場所を調べて正面をその視点にする
        if (this.current_turn_self_p) {       // 自分が手番なら
          // this.tn_notify()                 // 牛
          this.tl_alert(`${this.user_name}から開始を${this.user_name}だけに通知`)
        }
        this.$sound.play("rooster")
      }
    },

    // private

    // 最初の PLAY か？
    first_play_trigger_p(params) {
      return params.cc_key === "ck_start"
    },

    cc_play_confirm(params = {}) {
      this.$sound.play_click()
      this.talk2("ちょっと待って。先に順番設定をしてください")
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
      Gs.assert(_.isArray(params), "_.isArray(params)")
      const values = params.map(params => CcRuleInfo.cc_params_keys.map(e => params[e]))
      return JSON.stringify(values)
    },

    cc_params_debug(label, params) {
      this.tl_add("CC初期値", `${label}: ${this.cc_params_inspect(params)}`)
    },

    // 時間切れの状態を記録する → ck_timeout のログとかぶっているので不要
    cc_timeout_logging(params) {
      // if (this.received_from_self(params)) {
      //   const cc_info = CcInfo.fetch(params.cc_key)
      //   if (cc_info.key === "ck_timeout") {
      //     const body = [
      //       params.from_user_name,
      //       this.current_url,
      //     ]
      //     this.ac_log({subject: "時間切れ", body: Gs.short_inspect(body)})
      //   }
      // }
    },
  },

  computed: {
    CcRuleInfo() { return CcRuleInfo },
    CcInfo()     { return CcInfo     },

    cc_play_p()  { return this.clock_box && this.clock_box.play_p }, // 時計の状態 PLAY

    cc_common_p()  { return this.cc_params.length == 1 }, // 共通設定か？
    cc_unique_p()  { return this.cc_params.length == 2 }, // 個別設定か？

    // 共有する時計情報
    clock_share_data() {
      const params = {
        ...this.cc_params,
      }
      if (this.clock_box) {
        params.clock_box_attributes = this.clock_box.attributes
      }
      return params
    },

    // 順番設定を有効にしてないのに時計を開始しようとしている？
    cc_start_even_though_order_is_not_enabled_p() {
      return this.ac_room && !this.order_enable_p
    },
  },
}
