import consumer from "channels/consumer"
import dayjs from "dayjs"

export const application_room = {
  data() {
    return {
      g_mode: null,
      osenai_p: null,

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

    room_setup() {
      this.mode = "room"

      this.room_messages = []
      this.room_message = ""

      this.sub_mode = "standby"

      this.members_hash = {}
      this.room.memberships.forEach(e => {
        this.members_hash[e.id] = { progress_list: [], x_score: 0 }
      })

      this.question_index = 0

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

    ////////////////////////////////////////////////////////////////////////////////

    room_speak_handle() {
      this.room_speak(this.room_message)
      this.room_message = ""
    },

    room_speak(message) {
      this.$ac_room.perform("speak", {message: message})
    },

    room_speak_broadcasted(params) {
      const message = params.message
      if (!/^\*/.test(message.body)) {
        this.talk(message.body, {rate: 1.5})
      }
      this.$buefy.toast.open({message: `${message.user.name}: ${message.body}`, position: "is-top", queue: false})
      this.room_messages.push(message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    start_hook() {
      this.debug_alert("room 接続")
      this.ac_info_update()

      this.room_speak("*start_hook")
      this.$ac_room.perform("start_hook", {
        membership_id: this.current_membership.id,
        question_id: this.current_question_id,
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
      this.g_mode = "g_mode1"
      this.osenai_p = false
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.sub_mode === "operation_mode") {

        if (this.room.game_key === "game_key2") {
          // 安全のため残り0秒になってから操作しても無効とする
          if (this.q2_rest_seconds === 0) {
            return
          }

          // 駒を1つでも動かしたら3秒に復帰する
          if (this.g_mode === "g_mode2") {
            this.q2_interval_restart()
          }
        }

        if (this.current_quest_answers.includes(this.position_sfen_remove(long_sfen))) {
          this.kotae_sentaku("correct")
        }
        // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
        //   this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
        // }
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
        question_id: this.current_question_id, // 問題ID
        question_index: this.question_index + 1,
        ans_result_key: ans_result_key,
      }) // --> app/channels/actb/room_channel.rb
    },
    // 状況を反映する (なるべく小さなデータで共有する)
    kotae_sentaku_broadcasted(params) {
      this.members_hash[params.membership_id].progress_list.push(params.ans_result_key)

      if (this.room.game_key === "game_key2") {
        if (params.ans_result_key === "correct") {
          this.score_add(params.membership_id, 1)
        } else {
          this.score_add(params.membership_id, -1)
        }
      }

      // if (params.membership_id !== this.current_membership.id) {
      this.ox_sound_play(params.ans_result_key)
      // }

      if (this.room.game_key === "game_key1") {
        if (params.membership_id === this.current_membership.id) {
          // 次の問題がある場合
          if (this.question_index < this.current_best_question_size - 1) {
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

      if (this.room.game_key === "game_key2") {
        if (this.question_index < this.current_best_question_size - 1) {
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
        question_id: this.room.best_questions[this.question_index + 1],
        question_index: this.question_index + 1,
        current_best_question_size: this.current_best_question_size,
      }) // --> app/channels/actb/room_channel.rb

      this.deden_mode_trigger()
    },
    next_trigger_broadcasted(params) {
      this.room_speak("*next_trigger_broadcasted")
      if (this.room.game_key === "game_key1") {
        if (params.membership_id === this.current_membership.id) {
          this.question_index = params.question_index
        }
      }
      if (this.room.game_key === "game_key2") {
        this.question_index = params.question_index
      }
    },

    // 終了
    katimashita_broadcasted(params) {
      this.mode = "result"
      this.room = params.room
    },

    // 早押しボタンを押した(解答権はまだない)
    g2_hayaosi_handle() {
      this.sound_play("click")

      this.room_speak("*g2_hayaosi_handle")
      this.$ac_room.perform("g2_hayaosi_handle", {
        membership_id: this.current_membership.id,
        question_id: this.current_question_id,
        // question_index: this.question_index,
        // current_best_question_size: this.current_best_question_size,
      }) // --> app/channels/actb/room_channel.rb
    },
    g2_hayaosi_handle_broadcasted(params) {
      this.room_speak("*g2_hayaosi_handle_broadcasted")
      if (params.membership_id === this.current_membership.id) {
        // 先に解答ボタンを押せた本人
        this.g_mode = "g_mode2"
        this.q2_interval_start()
      } else {
        // 解答ボタンを押さなかった相手
        if (this.osenai_p) {
          this.osenai_p = false // 元々誤答していたら解答権利復活させる
        }
        this.g_mode = "g_mode3"
      }
    },

    // 早押しボタンを押して解答中に時間切れ
    g2_jikangire_handle() {
      this.room_speak("*g2_jikangire_handle")
      this.$ac_room.perform("g2_jikangire_handle", {
        membership_id: this.current_membership.id,
        question_id: this.current_question_id,
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
      this.g_mode = "g_mode1"
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
      if (this.room.game_key === "game_key1") {
        if (this.sub_mode === "operation_mode") {
          this.q1_interval_count += 1
          if (this.q1_rest_seconds === 0) {
            this.kotae_sentaku('mistake')
          }
        }
      }
      if (this.room.game_key === "game_key2") {
        if (this.sub_mode === "operation_mode") {
          if (this.g_mode === "g_mode1") {
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
    current_best_question() {
      return this.room.best_questions[this.question_index]
    },
    current_best_question_size() {
      return this.room.best_questions.length
    },
    current_quest_init_sfen() {
      const info = this.current_best_question
      if (info) {
        return info.init_sfen
      }
    },
    current_quest_answers() {
      const info = this.current_best_question
      if (info) {
        return info.moves_answers.map(e => [info.init_sfen, "moves", e.moves_str].join(" "))
      }
    },
    current_question_id() {
      const info = this.current_best_question
      if (info) {
        return info.id
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    q_record() {
      return this.current_best_question
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
      return this.q_record.time_limit_sec
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
