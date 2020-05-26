import { Question } from "./question.js"
import { Battle } from "./battle.js"

import consumer from "channels/consumer"
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
      q1_interval_id: null,
      q1_interval_count: null,

      q2_interval_id: null,
      q2_interval_count: null,

      // 各 membership_id はどこまで進んでいるかわかる
      // {
      //   3 => ["correct", "mistake"],
      // }
      members_hash: null,
    }
  },

  methods: {
    battle_unsubscribe() {
      if (this.$ac_battle) {
        this.$ac_battle.unsubscribe()
        this.$ac_battle = null
        this.ac_info_update()
      }
    },

    battle_setup(battle) {
      this.battle_unsubscribe()

      this.battle = new Battle(battle)
      this.__assert__(this.battle.best_questions.length >= 1, "best_questions is empty")

      this.mode = "battle"

      this.battle_continue_tap_counts = {}

      this.sub_mode = "standby"

      this.members_hash = {}
      this.battle.memberships.forEach(e => {
        this.members_hash[e.id] = { ox_list: [], x_score: 0 }
      })

      this.question_index = 0

      this.__assert__(this.$ac_battle == null)
      this.$ac_battle = consumer.subscriptions.create({ channel: "Actb::BattleChannel", battle_id: this.battle.id }, {
        connected: () => {
          this.ac_info_update()
          this.start_hook()
        },
        disconnected: () => {
          this.ac_info_update()
          this.debug_alert("battle 切断")
          // 切断してすぐ接続したときあとで新しく接続したあとで前の disconnected が呼ばれるかもしれない
          // なので、ここで this.$ac_battle = null はしてはいけない
        },
        received: (data) => {
          this.debug_alert("battle 受信")
          if (data.bc_action) {
            this[data.bc_action](data.bc_params)
          }
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      if (this.info.debug_scene === "result") {
        this.result_setup(this.info.battle)
        return
      }

      this.battle_count += 1

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

        if (this.battle.rule_key === "singleton_rule") {
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
        // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
        //   this.$ac_battle.perform("goal_hook") // --> app/channels/actb/battle_channel.rb
        // }
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
      const ox_mark_info = this.$OxMarkInfo.fetch(params.ox_mark_key)

      // ○×反映
      this.members_hash[params.membership_id].ox_list.push(params.ox_mark_key)
      // 効果音
      this.sound_play(ox_mark_info.sound_key)

      if (this.battle.rule_key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          // 次の問題がある場合
          if (this.tugino_mondai_ga_aru) {
            if (params.ox_mark_key === "correct") {
              this.sub_mode = "correct_mode"
              this.delay(this.config.correct_mode_delay, () => {
                this.next_trigger()
              })
            } else {
              this.sub_mode = "mistake_mode"
              this.delay(this.config.mistake_mode_delay, () => {
                this.next_trigger()
              })
            }
          } else {
            if (params.ox_mark_key === "correct") {
              this.sub_mode = "correct_mode"
              this.delay(this.config.correct_mode_delay, () => {
                this.$ac_battle.perform("goal_hook") // --> app/channels/actb/battle_channel.rb
              })
            } else {
              this.sub_mode = "mistake_mode"
              this.delay(this.config.mistake_mode_delay, () => {
                this.$ac_battle.perform("goal_hook") // --> app/channels/actb/battle_channel.rb
              })
            }
          }
        }
      }

      if (this.battle.rule_key === "singleton_rule") {
        this.score_add(params.membership_id, ox_mark_info.score)
        this.sub_mode = `${ox_mark_info.key}_mode` // correct_mode or mistake_mode
        this.delay(ox_mark_info.delay_second, () => {
          if (this.primary_membership_p) {
            if (this.score_max_natta_p || this.tugino_mondai_ga_nai) {
              this.$ac_battle.perform("owattayo", {members_hash: this.members_hash}) // --> app/channels/actb/battle_channel.rb
            } else {
              this.next_trigger()
            }
          }
        })
      }
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
      if (this.battle.rule_key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index // 自分だったら次に進める
        }
      }
      if (this.battle.rule_key === "singleton_rule") {
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
      const member = this.members_hash[membership_id]
      let v = member.x_score + diff
      if (v < 0) {
        v = 0
      }
      this.$set(member, "x_score", v)
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
      this.battle = battle
      this.mode = "result"
      this.sound_play(this.app.current_membership.judge_key)
    },

    yameru_handle() {
      this.room_speak("bye")
      this.lobby_handle()
    },

    ////////////////////////////////////////////////////////////////////////////////
    q1_interval_start() {
      this.q1_interval_clear()
      this.q1_interval_count = 0
      this.q1_interval_id = setInterval(this.q1_interval_processing, 1000)
    },

    q1_interval_clear() {
      if (this.q1_interval_id) {
        clearInterval(this.q1_interval_id)
        this.q1_interval_id = null
      }
    },

    q1_interval_processing() {
      if (this.battle.rule_key === "marathon_rule") {
        if (this.sub_mode === "operation_mode") {
          this.q1_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('mistake')
          }
        }
      }
      if (this.battle.rule_key === "singleton_rule") {
        if (this.sub_mode === "operation_mode") {
          if (this.x_mode === "x1_idol") {
            this.q1_interval_count += 1
            if (this.q1_rest_seconds === 0) {
              this.kotae_sentaku('mistake')
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
      let v = this.q1_time_limit_sec - this.q1_interval_count
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

    tugino_mondai_ga_aru() {
      return !this.tugino_mondai_ga_nai
    },
    tugino_mondai_ga_nai() {
      return (this.question_index + 1) >= this.battle.questions_count
    },

    score_orderd_memberships() {
      return _.sortBy(this.battle.memberships, e => -this.members_hash[e.id].x_score)
    },
    score_debug_info() {
      return this.score_orderd_memberships.map(e => `${e.user.name}(${this.members_hash[e.id].x_score})`).join(", ")
    },
    score_max() {
      return _.max(_.map(this.members_hash, (e, membership_id) => e.x_score))
    },
    score_max_natta_p() {
      return this.score_max >= this.app.config.nanmonkotaetara_kati
    },
  },
}
