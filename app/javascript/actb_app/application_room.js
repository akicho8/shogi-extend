import { Question } from "./question.js"
import { Room } from "./room.js"

import consumer from "channels/consumer"
import dayjs from "dayjs"

export const application_room = {
  data() {
    return {
      x_mode: null,
      osenai_p: null,
      share_sfen: null,         // 自分の操作を相手に伝えるためのあれ

      q_turn_offset: null,
      q1_interval_id: null,
      q1_interval_count: null,

      q2_interval_id: null,
      q2_interval_count: null,

      question_index:  null, // 正解中の問題インデックス

      // 各 membership_id はどこまで進んでいるかわかる
      // {
      //   3 => ["correct", "mistake"],
      //   4 => ["correct", "correct"],
      // }
      members_hash: null,
    }
  },

  methods: {
    room_unsubscribe() {
      if (this.$ac_room) {
        this.$ac_room.unsubscribe()
        this.$ac_room = null
        this.ac_info_update()
      }
    },

    room_setup(room) {
      this.room_setup_without_ac_room(room)

      this.__assert(this.$ac_room == null)
      this.$ac_room = consumer.subscriptions.create({ channel: "Actb::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.start_hook()
        },
        disconnected: () => {
          alert("room disconnected")
          this.debug_alert("room 切断")
          this.ac_info_update()
        },
        received: (data) => {
          this.debug_alert("room 受信")
          if (data.bc_action) {
            this[data.bc_action](data.bc_params)
          }
        },
      })
    },
    room_setup_without_ac_room(room) {
      this.room = new Room(room)

      this.mode = "room"

      this.room_messages = []
      this.room_message = ""

      this.sub_mode = "standby"

      this.members_hash = {}
      this.room.memberships.forEach(e => {
        this.members_hash[e.id] = { progress_list: [], x_score: 0 }
      })

      this.question_index = 0
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_speak_handle() {
      this.room_speak(this.room_message)
      this.room_message = ""
    },

    room_speak(message) {
      this.$ac_room.perform("speak", {message: message})
    },

    room_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.room_messages.push(params.message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      this.debug_alert("room 接続")
      this.ac_info_update()

      this.room_speak("*start_hook")
      this.$ac_room.perform("start_hook", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
        question_index: this.question_index,
      }) // --> app/channels/actb/room_channel.rb

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
      this.osenai_p = false
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

        if (this.room.rule_key === "singleton_rule") {
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
        //   this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
        // }
      }
    },

    kyouyuu(share_sfen) {
      this.room_speak(`*kyouyuu("${share_sfen}")`)
      this.$ac_room.perform("kyouyuu", { // 戻値なし
        membership_id: this.current_membership.id,
        share_sfen: share_sfen,
      }) // --> app/channels/actb/room_channel.rb
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
    kotae_sentaku(ans_result_key) {
      // this.ox_sound_play(ans_result_key)

      // if (ans_result_key === "correct") {
      //   this.score_add(1)
      // } else {
      //   this.score_add(-1)
      // }

      this.room_speak(`*kotae_sentaku("${ans_result_key}")`)
      this.$ac_room.perform("kotae_sentaku", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id, // 問題ID
        question_index: this.question_index + 1,
        ans_result_key: ans_result_key,
      }) // --> app/channels/actb/room_channel.rb
    },
    // 状況を反映する
    kotae_sentaku_broadcasted(params) {
      // ○×の反映
      this.members_hash[params.membership_id].progress_list.push(params.ans_result_key)

      if (this.room.rule_key === "singleton_rule") {
        if (params.ans_result_key === "correct") {
          this.score_add(params.membership_id, 1)
        } else {
          this.score_add(params.membership_id, -1)
        }
      }

      // if (params.membership_id !== this.current_membership.id) {
      this.ox_sound_play(params.ans_result_key)
      // }

      if (this.room.rule_key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          // 次の問題がある場合
          if (this.question_index < this.room.questions_count - 1) {
            if (params.ans_result_key === "correct") {
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
            if (params.ans_result_key === "correct") {
              this.sub_mode = "correct_mode"
              this.delay(this.config.correct_mode_delay, () => {
                this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
              })
            } else {
              this.sub_mode = "mistake_mode"
              this.delay(this.config.mistake_mode_delay, () => {
                this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
              })
            }
          }
        }
      }

      if (this.room.rule_key === "singleton_rule") {
        if (this.question_index < this.room.questions_count - 1) {
          if (params.ans_result_key === "correct") {
            this.sub_mode = "correct_mode"
            this.delay(this.config.correct_mode_delay, () => {
              if (this.primary_membership_p) {
                this.next_trigger()
              }
            })
          } else {
            this.sub_mode = "mistake_mode"
            this.delay(this.config.mistake_mode_delay, () => {
              if (this.primary_membership_p) {
                this.next_trigger()
              }
            })
          }
        } else {
          if (params.ans_result_key === "correct") {
            this.sub_mode = "correct_mode"
            this.delay(this.config.correct_mode_delay, () => {
              if (this.primary_membership_p) {
                this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
              }
            })
          } else {
            this.sub_mode = "mistake_mode"
            this.delay(this.config.mistake_mode_delay, () => {
              if (this.primary_membership_p) {
                this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
              }
            })
          }
        }
      }
    },

    next_trigger() {
      this.room_speak("*next_trigger")
      this.$ac_room.perform("next_trigger", { // 戻値なし
        membership_id: this.current_membership.id,
        question_index: this.question_index + 1, // 次に進めたい(希望)
      }) // --> app/channels/actb/room_channel.rb

      this.deden_mode_trigger()
    },
    next_trigger_broadcasted(params) {
      this.room_speak("*next_trigger_broadcasted")
      if (this.room.rule_key === "marathon_rule") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index // 自分だったら次に進める
        }
      }
      if (this.room.rule_key === "singleton_rule") {
        this.question_index = params.question_index // 相手もそろって次に進める
      }
    },

    // 早押しボタンを押した(解答権はまだない)
    g2_hayaosi_handle() {
      this.sound_play("click")

      this.room_speak("*g2_hayaosi_handle")
      this.$ac_room.perform("g2_hayaosi_handle", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
        // question_index: this.question_index,
      }) // --> app/channels/actb/room_channel.rb
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
        if (this.osenai_p) {
          this.osenai_p = false // 元々誤答していたら解答権利復活させる
        }
        this.x_mode = "x3_see"
        this.share_sfen = this.c_quest.full_init_sfen // 初期状態にしておく
        this.sound_play("poon")
      }
    },

    // 早押しボタンを押して解答中に時間切れ
    g2_jikangire_handle() {
      this.room_speak("*g2_jikangire_handle")
      this.$ac_room.perform("g2_jikangire_handle", {
        membership_id: this.current_membership.id,
        question_id: this.c_quest.id,
      }) // --> app/channels/actb/room_channel.rb
    },
    // 時間切れ
    g2_jikangire_handle_broadcasted(params) {
      this.room_speak("*g2_jikangire_handle_broadcasted")
      if (params.membership_id === this.current_membership.id) {
        this.score_add(this.current_membership.id, -1)
        this.osenai_p = true
      } else {
        this.osenai_p = false
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
      this.mode = "result"
      this.room = params.room

      this.sound_play(this.app.current_membership.judge_key)
    },

    ////////////////////////////////////////////////////////////////////////////////

    ox_sound_play(ans_result_key) {
      if (ans_result_key === "correct") {
        this.sound_play("pipopipo")
      } else {
        this.sound_play("bubuu")
      }
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
      if (this.room.rule_key === "marathon_rule") {
        if (this.sub_mode === "operation_mode") {
          this.q1_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('mistake')
          }
        }
      }
      if (this.room.rule_key === "singleton_rule") {
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
      return this.room.memberships[0].id === this.current_membership.id
    },
    current_membership() {
      return this.room.memberships.find(e => e.user.id === this.current_user.id)
    },
    c_quest() {
      const v = this.room.best_questions[this.question_index]
      this.__assert(v, "this.room.best_questions[this.question_index]")
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
  },
}
