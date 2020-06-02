import { Question } from "./models/question.js"
import { Battle } from "./models/battle.js"
import { MemberInfo } from "./models/member_info.js"

import dayjs from "dayjs"

export const application_battle = {
  data() {
    return {
      x_mode:                     null,  // バトル中の状態遷移
      answer_button_disable_p:    null,  // true:誤答でおてつき中
      battle_continue_tap_counts: null,  // それぞれの再戦希望数
      battle_count:               null,  // 同じ相手との対戦回数
      share_sfen:                 null,  // 自分の操作を相手に伝える棋譜
      question_index:             null,  // 現在の問題インデックス

      q_turn_offset: null,
      main_interval_id: null,
      main_interval_count: null,

      q2_interval_id: null,
      q2_interval_count: null,

      // 各 membership_id はどこまで進んでいるかわかる
      // {
      //   3 => ["correct", "mistake"],
      // }
      member_infos_hash: null,
    }
  },

  methods: {
    battle_unsubscribe() {
      this.ac_unsubscribe("$ac_battle")
    },

    battle_setup(battle) {
      this.battle_unsubscribe()

      this.battle = new Battle(battle)

      this.mode = "battle"

      this.battle_continue_tap_counts = {}

      this.sub_mode = "standby"

      this.member_infos_hash = this.battle.memberships.reduce((a, e) => ({...a, [e.id]: new MemberInfo()}), {})

      this.question_index = 0

      this.__assert__(this.$ac_battle == null)
      this.$ac_battle = this.ac_subscription_create({channel: "Actb::BattleChannel", battle_id: this.battle.id}, {
        connected: () => {
          this.start_hook()
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      this.battle_count += 1

      if (this.info.debug_scene === "result") {
        this.result_setup(this.info.battle)
        return
      }

      this.__assert__(this.battle.best_questions.length >= 1, "best_questions is empty")

      this.debug_alert("battle 接続")

      this.room_speak("*start_hook")
      this.$ac_battle.perform("start_hook", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
        question_index: this.question_index,
      }) // --> app/channels/actb/battle_channel.rb

      this.ok_notice("対戦開始")
      this.sub_mode = "readygo_wait"
      this.delay(this.config.readygo_wait_delay, () => {
        this.deden_mode_trigger()
      })
    },

    deden_mode_trigger() {
      this.sound_play("deden")
      this.sub_mode = "deden_mode"

      this.delay(this.config.deden_mode_delay, () => {
        this.operation_mode_trigger()
      })
    },

    operation_mode_trigger() {
      this.sub_mode = "operation_mode"
      this.x_mode = "x1_idol"
      this.answer_button_disable_p = false
      this.share_sfen = null
    },

    q_turn_offset_set(turn) {
      this.q_turn_offset = turn

      const max = this.c_quest.moves_count_max + this.config.asobi_count
      if (turn >= max) {
        this.g2_jikangire_handle()
      }
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.sub_mode === "operation_mode") {

        if (this.battle.rule.key === "singleton_rule") {
          // 安全のため残り0秒になってから操作しても無効とする
          if (this.q2_rest_seconds === 0) {
            return
          }

          // 駒を1つでも動かしたら3秒に復帰する
          if (this.x_mode === "x2_play") {
            this.q2_interval_restart()
          }

          this.kyouyuu(long_sfen)
        }

        if (this.c_quest.answer_p(long_sfen)) {
          this.kotae_sentaku("correct")
        }
      }
    },

    kyouyuu(share_sfen) {
      this.room_speak(`*kyouyuu("${share_sfen}")`)
      this.$ac_battle.perform("kyouyuu", { // 戻値なし
        membership_id: this.current_membership.id,
        share_sfen: share_sfen,
      }) // --> app/channels/actb/battle_channel.rb
    },
    kyouyuu_broadcasted(params) {
      this.room_speak("*kyouyuu_broadcasted")
      if (params.membership_id === this.current_membership.id) {
        // 自分は操作中なので何も変化させない
      } else {
        // 自分の操作を相手の盤面で動かす
        this.share_sfen = params.share_sfen
        this.sound_play("pishi") // shogi-player で音が鳴らないのでここで鳴らす
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 正解または不正解
    kotae_sentaku(ox_mark_key) {
      this.room_speak(`*kotae_sentaku("${ox_mark_key}")`)
      this.$ac_battle.perform("kotae_sentaku", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
        question_index: this.question_index,
        ox_mark_key: ox_mark_key,
      }) // --> app/channels/actb/battle_channel.rb
    },
    // 状況を反映する
    kotae_sentaku_broadcasted(params) {
      const ox_mark_info = this.OxMarkInfo.fetch(params.ox_mark_key) // 正解・不正解
      const mi = this.member_infos_hash[params.membership_id]          // 対応する membership の情報

      // ○×反映
      mi.ox_list.push(params.ox_mark_key)
      this.score_add(params.membership_id, ox_mark_info.score)

      // 効果音
      this.sound_play(ox_mark_info.sound_key)

      if (this.battle.rule.key === "marathon_rule") {
        this.delay_stop(mi.delay_id) // 前のが動いている場合があるので止める
        mi.latest_ox = ox_mark_info.key
        mi.delay_id = this.delay(ox_mark_info.delay_second, () => {
          mi.delay_id = null
          mi.latest_ox = null
        })

        // correct_mode or mistake_mode
        if (params.membership_id === this.current_membership.id) {
          this.sub_mode = `${ox_mark_info.key}_mode`
          this.delay_and_owattayo_or_next_trigger(ox_mark_info)
        }
      }

      if (this.battle.rule.key === "singleton_rule" || this.battle.rule.key === "hybrid_rule") {
        this.sub_mode = `${ox_mark_info.key}_mode` // correct_mode or mistake_mode
        if (this.primary_membership_p) {
          this.delay_and_owattayo_or_next_trigger(ox_mark_info)
        }
      }
    },
    delay_and_owattayo_or_next_trigger(ox_mark_info) {
      this.delay(ox_mark_info.delay_second, () => {
        if (this.battle_end_p || this.next_question_empty_p) {
          this.$ac_battle.perform("owattayo", {member_infos_hash: this.member_infos_hash}) // --> app/channels/actb/battle_channel.rb
        } else {
          this.next_trigger()
        }
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    next_trigger() {
      this.room_speak("*next_trigger")
      this.$ac_battle.perform("next_trigger", { // 戻値なし
        membership_id: this.current_membership.id,
        question_index: this.question_index + 1, // 次に進めたい(希望)
      }) // --> app/channels/actb/battle_channel.rb

      this.deden_mode_trigger()
    },
    next_trigger_broadcasted(params) {
      this.room_speak("*next_trigger_broadcasted")
      if (this.battle.rule.key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index // 自分だったら次に進める
        }
      }
      if (this.battle.rule.key === "singleton_rule" || this.battle.rule.key === "hybrid_rule") {
        this.question_index = params.question_index // 相手もそろって次に進める
      }
    },

    // 早押しボタンを押した(解答権はまだない)
    g2_hayaosi_handle() {
      this.sound_play("click")

      this.room_speak("*g2_hayaosi_handle")
      this.$ac_battle.perform("g2_hayaosi_handle", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
        // question_index: this.question_index,
      }) // --> app/channels/actb/battle_channel.rb
    },
    g2_hayaosi_handle_broadcasted(params) {
      this.room_speak("*g2_hayaosi_handle_broadcasted")
      if (params.membership_id === this.current_membership.id) {
        // 先に解答ボタンを押せた本人
        this.x_mode = "x2_play"
        this.q2_interval_start()
        this.sound_play("poon")
      } else {
        // 解答ボタンを押さなかった相手
        if (this.answer_button_disable_p) {
          this.answer_button_disable_p = false // 元々誤答していたら解答権利復活させる
        }
        this.x_mode = "x3_see"
        this.share_sfen = this.c_quest.full_init_sfen // 初期状態にしておく
        this.sound_play("poon")
      }
    },

    // 早押しボタンを押して解答中に時間切れ
    g2_jikangire_handle() {
      this.room_speak("*g2_jikangire_handle")
      this.$ac_battle.perform("g2_jikangire_handle", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
      }) // --> app/channels/actb/battle_channel.rb
    },
    // 時間切れ
    g2_jikangire_handle_broadcasted(params) {
      this.room_speak("*g2_jikangire_handle_broadcasted")
      if (params.membership_id === this.current_membership.id) {
        this.score_add(this.current_membership.id, -1)
        this.answer_button_disable_p = true
      } else {
        this.answer_button_disable_p = false
      }
      this.x_mode = "x1_idol"
      this.sound_play("bubuu")
      this.q2_interval_stop()
    },

    // private
    score_add(membership_id, diff) {
      const mi = this.member_infos_hash[membership_id]
      let v = mi.b_score + diff
      if (v < 0) {
        v = 0
      }
      mi.b_score = v
    },

    // 結果画面へ
    katimashita_broadcasted(params) {
      this.result_setup(params.battle)
    },

    battle_continue_handle() {
      this.sound_play("click")
      this.$ac_battle.perform("battle_continue_handle", {membership_id: this.current_membership.id})
    },
    battle_continue_handle_broadcasted(params) {
      this.room_speak("*battle_continue_handle_broadcasted")
      this.battle_continue_tap_counts = params.battle_continue_tap_counts

      this.talk("再戦希望", {rate: 1.5})
      this.$buefy.toast.open({message: "再戦希望", position: "is-top", queue: false})

      if (params.membership_id === this.current_membership.id) {
      } else {
      }
    },

    battle_continue_force_handle() {
      this.sound_play("click")
      this.$ac_battle.perform("battle_continue_force_handle")
    },

    ////////////////////////////////////////////////////////////////////////////////

    result_setup(battle) {
      this.battle = new Battle(battle)
      this.mode = "result"
      this.sound_play(this.app.current_membership.judge.key)
    },

    yameru_handle() {
      this.room_speak("bye")
      this.lobby_handle()
    },

    ////////////////////////////////////////////////////////////////////////////////
    main_interval_start() {
      this.main_interval_clear()
      this.main_interval_count = 0
      this.main_interval_id = setInterval(this.main_interval_processing, 1000)
    },

    main_interval_clear() {
      if (this.main_interval_id) {
        clearInterval(this.main_interval_id)
        this.main_interval_id = null
      }
    },

    main_interval_processing() {
      if (this.battle.rule.key === "marathon_rule" || this.battle.rule.key === "hybrid_rule") {
        if (this.sub_mode === "operation_mode") {
          this.main_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('timeout')
          }
        }
      }
      if (this.battle.rule.key === "singleton_rule") {
        if (this.sub_mode === "operation_mode") {
          if (this.x_mode === "x1_idol") {
            this.main_interval_count += 1
            if (this.q1_rest_seconds === 0) {
              this.kotae_sentaku('timeout')
            }
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    q2_interval_start() {
      this.q2_interval_stop()
      this.q2_interval_count = 0
      this.q2_interval_id = setInterval(this.q2_interval_processing, 1000)
    },

    q2_interval_stop() {
      if (this.q2_interval_id) {
        clearInterval(this.q2_interval_id)
        this.q2_interval_id = null
      }
    },

    q2_interval_restart() {
      this.q2_interval_stop()
      this.q2_interval_start()
    },

    q2_interval_processing() {
      if (this.sub_mode === "operation_mode") {
        this.q2_interval_count += 1
        if (this.q2_rest_seconds === 0) {
          this.g2_jikangire_handle()
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

  },

  computed: {

    primary_membership_p() {
      return this.battle.memberships[0].id === this.current_membership.id
    },
    current_membership() {
      const v = this.battle.memberships.find(e => e.user.id === this.current_user.id)
      this.__assert__(v, "current_membership is blank")
      return v
    },
    c_quest() {
      const v = this.battle.best_questions[this.question_index]
      this.__assert__(v, "c_quest is blank")
      return v
    },

    ////////////////////////////////////////////////////////////////////////////////

    q1_time_str() {
      return dayjs().startOf("year").set("seconds", this.q1_rest_seconds).format("mm:ss")
    },
    q1_rest_seconds() {
      let v = this.q1_time_limit_sec - this.main_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },
    q1_time_limit_sec() {
      // if (this.development_p) {
      //   return 3
      // }
      return this.c_quest.time_limit_sec
    },

    ////////////////////////////////////////////////////////////////////////////////

    q2_rest_seconds() {
      let v = this.config.q2_time_limit_sec - this.q2_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },

    ////////////////////////////////////////////////////////////////////////////////

    next_question_exist_p() {
      return !this.next_question_empty_p
    },
    next_question_empty_p() {
      return (this.question_index + 1) >= this.battle.questions_count
    },
    score_orderd_memberships() {
      return _.sortBy(this.battle.memberships, e => -this.member_infos_hash[e.id].b_score)
    },
    score_debug_info() {
      return this.score_orderd_memberships.map(e => `${e.user.name}(${this.member_infos_hash[e.id].b_score})`).join(", ")
    },
    b_score_max() {
      return _.max(_.map(this.member_infos_hash, (e, membership_id) => e.b_score))
    },

    // バトル終了条件
    battle_end_p() {
      return this.b_score_max >= this.app.config.b_score_max_for_win
    },
  },
}
