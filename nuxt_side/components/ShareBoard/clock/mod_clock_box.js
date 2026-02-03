const BYOYOMI_TALK_PITCH      = 1.65 // 秒読み発声速度。次の発声に被らないようにする。速くても人間が予測できるので聞き取れる
const CC_INPUT_DEBOUNCE_DELAY = 0.5  // 時計の同期のために操作が終わったと判断する秒数
const CC_KOREYORI_DELAY       = 1.0  // N秒の発声とかぶるためすこし間を空けてから発言する

import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { CcRuleInfo } from "@/components/models/cc_rule_info.js"
import { CcBehaviorInfo     } from "./cc_behavior_info.js"
import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export const mod_clock_box = {
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
      this.cc_params = [{ initial_main_min: 60, initial_read_sec: 15, initial_extra_min: 10, every_plus: 5 }]
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    }
  },

  beforeDestroy() {
    this.cc_destroy()
  },

  methods: {
    // for room_after_create
    // パラメータ設置なしで開始する
    cc_auto_start() {
      this.cc_create()
      this.cc_params_apply()
      this.clock_box.play_handle()
    },
    // for room_after_create
    // 10分で開始する
    cc_auto_start_10m() {
      this.cc_params = [{ initial_main_min: 10, initial_read_sec: 0, initial_extra_min: 0, every_plus: 0 }]
      this.cc_auto_start()
    },

    ////////////////////////////////////////////////////////////////////////////////

    cc_play_by(initial_main_min = 10, initial_read_sec = 30, initial_extra_min = 0, every_plus = 0) {
      this.cc_params = [
        {
          initial_main_min: initial_main_min,
          initial_read_sec: initial_read_sec,
          initial_extra_min: initial_extra_min,
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
        "initial_extra_min",
        "every_plus",
      ].forEach(column => {
        const key = `clock_box.${column}`
        const value = this.$route.query[key]
        if (GX.present_p(value)) {
          const iv = parseInt(value)
          this.$set(this.cc_params[0], column, iv)
        }
      })
    },

    cc_main_switch_set(v) {
      if (v) {
        this.cc_create()
        this.cc_params_apply() // ONにしたらすぐにパラメータを反映する
        this.clock_box_share("cc_behavior_on")
      } else {
        this.cc_destroy()
        this.clock_box_share("cc_behavior_off")
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
        read_koreyori_fn: context => this.cc_read_koreyori(context.initial_read_sec),
        extra_koreyori_fn: context => this.cc_extra_koreyori(context.initial_extra_sec),
        time_zero_fn: e => this.cc_timeout_trigger(),
        pause_tick_fn: this.cc_pause_tick_callback,
        switched_fn: () => {
          // this.sfx_click()
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

    cc_pause_tick_callback(mm, ss) {
      if (ss === 0 && mm >= 1) {
        this.sfx_play("se_notification")
        this.toast_primary(`${mm}分経過`)
      }
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

    async cc_read_koreyori(sec) {
      await GX.sleep(CC_KOREYORI_DELAY)
      this.cc_talk(`これより1手${sec}秒でお願い致します`)
    },

    async cc_extra_koreyori(sec) {
      await GX.sleep(CC_KOREYORI_DELAY)
      this.cc_talk(`考慮時間が0になったら負けなので御注意ください`)
    },

    cc_talk(s, options = {}) {
      this.cc_notice(s, {toast: false, ...options})
    },

    cc_notice(s, options = {}) {
      options = {
        type: "is-primary",
        rate: BYOYOMI_TALK_PITCH,
        volume_local_user_scale: this.volume_clock_user_scale,
        ...options,
      }
      this.toast_primitive(s, options)
    },

    cc_destroy() {
      if (this.clock_box) {
        this.clock_box.stop_handle() // timer_stop ではなく完全停止で一時停止中のタイマーも止める
        this.clock_box = null
      }
    },

    //////////////////////////////////////////////////////////////////////////////// resume

    cc_resume_handle() {
      if (this.cc_pause_p) {
        this.clock_box.resume_handle()
      }
    },
    cc_resume_silent_share() {
      if (this.cc_pause_p) {
        this.cc_resume_handle()
        this.clock_box_share("cc_behavior_resume_silent")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// pause

    cc_pause_handle() {
      if (this.cc_play_p) {
        this.clock_box.pause_handle()
      }
    },
    cc_pause_silent_share() {
      if (this.cc_play_p) {
        this.cc_pause_handle()
        this.clock_box_share("cc_behavior_pause_silent")
      }
    },

    //////////////////////////////////////////////////////////////////////////////// stop

    cc_stop_handle() {
      if (this.cc_pause_or_play_p) {
        this.clock_box.stop_handle()
      }
    },
    cc_stop_share_handle() {
      if (this.cc_pause_or_play_p) {
        this.cc_stop_handle()
        this.clock_box_share("cc_behavior_stop_silent")
      }
    },

    // 順番OFFであれば時計を停止する
    order_off_then_cc_stop() {
      if (!this.order_enable_p) {
        if (this.clock_box) {
          this.clock_box.stop_handle()
        }
      }
    },

    //////////////////////////////////////////////////////////////////////////////// play

    cc_play_handle() {
      if (this.cc_stop_p) {
        this.clock_box.play_handle()
      }
    },
    // cc_params を clock_box に適用する
    // このタイミングで cc_params を localStorage に保存する
    cc_params_apply() {
      this.cc_params_apply_without_save()
      this.cc_params_save()
    },
    cc_params_apply_without_save() {
      GX.assert(_.isArray(this.cc_params), "_.isArray(this.cc_params)")
      GX.assert(this.cc_params.length >= 1, "this.cc_params.length >= 1")

      const ary = this.clock_box.single_clocks.map((e, i) => this.cc_params_one_to_clock_box_params(this.cc_params[i] || this.cc_params[0]))
      this.clock_box.rule_set_all_by_ary(ary)
    },

    // 共有将棋盤では扱いやすいように持ち時間は分にしている
    // 一方、時計は秒で管理しているため秒単位に変換する
    cc_params_one_to_clock_box_params(params) {
      GX.assert(GX.present_p(params.initial_main_min), "GX.present_p(params.initial_main_min)")
      GX.assert(GX.present_p(params.initial_read_sec), "GX.present_p(params.initial_read_sec)")
      GX.assert(GX.present_p(params.initial_extra_min), "GX.present_p(params.initial_extra_min)")
      GX.assert(GX.present_p(params.every_plus), "GX.present_p(params.every_plus)")

      return {
        initial_main_sec:  params.initial_main_min * 60,
        initial_read_sec:  params.initial_read_sec,
        initial_extra_sec: params.initial_extra_min * 60, // ここで undefined * 60 をすると NaN になって NaN ?? 0 も NaN になってしまうので絶対に整数は入ってないとバグる
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
      this.clock_box_share("cc_behavior_input") // みんなへの同期も操作後にする
    }, 1000 * CC_INPUT_DEBOUNCE_DELAY),

    ////////////////////////////////////////////////////////////////////////////////

    // 時計の状態をすべて共有するためのパラメータを作る
    clock_box_share_params_factory(cc_behavior_key, params = {}) {
      const cc_behavior_info = CcBehaviorInfo.fetch(cc_behavior_key)
      params = {
        cc_behavior_key: cc_behavior_info.key,
        cc_behavior_name: cc_behavior_info.name,
        talk: true,
        ...params,
        ...this.clock_share_dto,
      }
      if (cc_behavior_info.with_url) {
        params.current_url = this.current_url // 棋譜再現URLをログに出すため
      }
      if (cc_behavior_info.with_member_data) {
        params.member_data = this.player_names_with_title_as_human_text
      }
      if (cc_behavior_info.log_level) {
        params.log_level = cc_behavior_info.log_level
      }
      return params
    },
    // 時計の状態をすべて共有する
    clock_box_share(cc_behavior_key, params = {}) {
      params = this.clock_box_share_params_factory(cc_behavior_key, params)
      this.ac_room_perform("clock_box_share", params) // --> app/channels/share_board/room_channel.rb
    },
    async clock_box_share_broadcasted(params) {
      const cc_behavior_info = CcBehaviorInfo.fetch(params.cc_behavior_key)
      this.tl_add("時計受信", `${params.from_user_name} -> ${this.user_name}`, params)
      this.tl_alert("時計同期")

      if (this.received_from_self(params)) {
      } else {
        this.clock_share_dto_receive(params)
      }

      this.__cc_action_log_store(params)         // 履歴追加
      this.__cc_location_change_and_call(params) // 視点変更とニワトリ

      if (cc_behavior_info.key === "cc_behavior_timeout") {
        this.cc_timeout_modal_open_if_not_exist()
      } else if (cc_behavior_info.key === "cc_behavior_start") {
        this.__cc_start_call(params)
      } else if (cc_behavior_info.key === "cc_behavior_on") {
        await this.toast_primary(this.__cc_receive_message(params))
        if (this.received_from_self(params)) {
          this.toast_primary("時間を設定したら対局を開始しよう", {duration_sec: 3})
        }
      } else if (cc_behavior_info.toast_p) {
        this.toast_primary(this.__cc_receive_message(params), {talk: cc_behavior_info.with_talk})
      }

      this.ai_say_case_clock(params)
    },
    __cc_receive_message(params) {
      const cc_behavior_info = CcBehaviorInfo.fetch(params.cc_behavior_key)
      return `${this.user_call_name(params.from_user_name)}が${cc_behavior_info.receive_message}`
    },
    async __cc_start_call(params) {
      await this.toast_primary(this.__cc_receive_message(params))
      // その後でPLAYの初回なら誰か初手を指すかしゃべる(全員)
      if (this.current_turn_user_name) {
        await this.toast_primary(`${this.user_call_name(this.current_turn_user_name)}から指そう`)
        this.think_mark_invite_trigger()
      }
    },

    // setup_info_send_broadcasted から呼ばれたときは from_user_name は入っていないので注意
    clock_share_dto_receive(params) {
      GX.assert(GX.present_p(params), "GX.present_p(params)")
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
      const cc_behavior_info = CcBehaviorInfo.fetch(params.cc_behavior_key)
      if (cc_behavior_info.history) {
        params = {
          ...params,
          label: cc_behavior_info.label,
          label_type: cc_behavior_info.label_type,
          clock_box_attributes: null, // 容量が大きいので空にしておく
          current_url: null, // 絶対に使わないので消しておく
        }
        this.al_add(params)
      }
    },

    __cc_location_change_and_call(params) {
      if (this.first_play_trigger_p(params)) { // PLAYの初回なら
        // 開始時の処理
        // this.sp_viewpoint_switch_to_my_location()               // 自分の場所を調べて正面をその視点にする
        if (this.current_turn_self_p) {       // 自分が手番なら
          // this.tn_bell_call()                 // 牛
          this.tl_alert(`${this.user_name}から開始を${this.user_name}だけに通知`)
        }
        this.honpu_all_clear()  // 本譜を消す (消さなくても cc_play_p のときは非表示になるのでいらないかも)
        this.sfx_play("se_niwatori")
      }
    },

    // private

    // 最初の PLAY か？
    first_play_trigger_p(params) {
      return params.cc_behavior_key === "cc_behavior_start"
    },

    // 順番設定で更新を押したあとで呼ぶ
    cc_next_message() {
      let message = null
      if (this.clock_box) {
        if (this.clock_box.current_status === "pause") {
          message = "次は時計を再開しよう"
        }
        if (this.clock_box.current_status === "stop") {
          message = "次は時計を設定しよう"
        }
      } else {
        message = "次は時計を設置しよう"
      }
      this.toast_primary(message)
    },

    cc_params_inspect(params) {
      GX.assert(_.isArray(params), "_.isArray(params)")
      const values = params.map(params => CcRuleInfo.cc_params_keys.map(e => params[e]))
      return JSON.stringify(values)
    },

    cc_params_debug(label, params) {
      this.tl_add("CC初期値", `${label}: ${this.cc_params_inspect(params)}`)
    },

    cc_play_confirim(params = {}) {
      this.sfx_click()
      this.sb_talk(`ちょっと待って。途中の局面になっています。初期配置に戻してから開始しますか？`)
      this.dialog_confirm({
        title: "ちょっと待って",
        // type: "is-warning",
        hasIcon: false,
        message: `<p>途中の局面になっています</p><p>初期配置に戻してから開始しますか？</p>`,
        confirmText: "はい",
        cancelText: `いいえ`,
        focusOn: "confirm",
        canCancel: ["button"],
        ...params,
      })
    },

  },

  computed: {
    CcRuleInfo()     { return CcRuleInfo     },
    CcBehaviorInfo() { return CcBehaviorInfo },

    // 時計の状態
    cc_stop_p()          { return this.clock_box?.stop_p          },
    cc_play_p()          { return this.clock_box?.play_p          },
    cc_pause_or_play_p() { return this.clock_box?.pause_or_play_p },
    cc_pause_p()         { return this.clock_box?.pause_p         },

    cc_common_p()  { return this.cc_params.length === 1 }, // 共通設定か？
    cc_unique_p()  { return this.cc_params.length === 2 }, // 個別設定か？

    // 共有する時計情報
    clock_share_dto() {
      const params = {}
      params.cc_params = this.cc_params
      if (this.clock_box) {
        params.clock_box_attributes = this.clock_box.attributes
      }
      return params
    },
  },
}
