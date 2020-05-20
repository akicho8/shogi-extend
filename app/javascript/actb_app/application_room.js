const READYGO_WAIT_DELAY = 2.5
const DEDEN_MODE_DELAY  = 0.8
const CORRECT_MODE_DELAY = 1
const MISTAKE_MODE_DELAY = 1

import consumer from "channels/consumer"

export const application_room = {
  data() {
    return {
      sub_mode:        null, // 正解直後に間を開けているとき true になっている
      question_index:  null, // 正解中の問題インデックス

      // 各 membership_id はどこまで進んでいるかわかる
      // {
      //   3 => ["correct", "mistake"],
      //   4 => ["correct", "correct"],
      // }
      progress_info:   null,
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
      this.progress_info = {}
      this.question_index = 0

      this.__assert(this.$ac_room == null)
      this.$ac_room = consumer.subscriptions.create({ channel: "Actb::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.debug_alert("room 接続")
          this.ac_info_update()

          this.$ac_room.perform("start_hook", {
            membership_id: this.current_membership.id,
            question_id: this.current_question_id,
            question_index: this.question_index,
          }) // --> app/channels/actb/room_channel.rb

          this.ok_notice("対戦開始")
          this.sub_mode = "readygo_wait"
          this.delay(READYGO_WAIT_DELAY, () => {
            this.deden_mode_trigger()
          })
        },
        disconnected: () => {
          alert("room disconnected")
          this.debug_alert("room 切断")
          this.ac_info_update()
        },
        received: (data) => {
          this.debug_alert("room 受信")

          // チャット
          if (data.message) {
            const message = data.message

            this.$buefy.toast.open({message: `${message.user.name}: ${message.body}`, position: "is-top", queue: false})
            this.talk(message.body, {rate: 1.5})

            this.room_messages.push(message)
          }

          // 状況を反映する (なるべく小さなデータで共有する)
          if (data.correct_hook) {
            const e = data.correct_hook

            if (!this.progress_info[e.membership_id]) {
              this.$set(this.progress_info, e.membership_id, [])
            }
            this.progress_info[e.membership_id].push(e.ans_result_key)

            if (e.membership_id !== this.current_membership.id) {
              this.ox_sound_play(e.ans_result_key)
            }
          }

          // 終了
          if (data.switch_to === "result") {
            this.mode = "result"
            this.room = data.room
          }
        },
      })
    },

    deden_mode_trigger() {
      this.sound_play("deden")
      this.sub_mode = "deden_mode"

      this.delay(DEDEN_MODE_DELAY, () => {
        this.solve_mode_trigger()
      })
    },

    solve_mode_trigger() {
      this.sub_mode = "solve_mode"
    },

    next_trigger() {
      this.question_index += 1

      this.$ac_room.perform("next_hook", {
        membership_id: this.current_membership.id,
        question_id: this.current_question_id,
        question_index: this.question_index,
        current_best_question_size: this.current_best_question_size,
      }) // --> app/channels/actb/room_channel.rb

      this.deden_mode_trigger()
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.sub_mode === "solve_mode") {
        if (this.current_quest_answers.includes(this.position_sfen_remove(long_sfen))) {
          this.kotae_sentaku("correct")
        }
        // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
        //   this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
        // }
      }
    },

    // 正解または不正解
    kotae_sentaku(ans_result_key) {
      this.ox_sound_play(ans_result_key)

      this.$ac_room.perform("correct_hook", {
        membership_id: this.current_membership.id,
        question_id: this.current_question_id, // 問題ID
        question_index: this.question_index + 1,
        ans_result_key: ans_result_key,
      }) // --> app/channels/actb/room_channel.rb

      // 次の問題がある場合
      if (this.question_index < this.current_best_question_size - 1) {
        if (ans_result_key === "correct") {
          this.sub_mode = "correct_mode"
          this.delay(CORRECT_MODE_DELAY, () => {
            this.next_trigger()
          })
        } else {
          this.sub_mode = "mistake_mode"
          this.delay(MISTAKE_MODE_DELAY, () => {
            this.next_trigger()
          })
        }
      } else {
        if (ans_result_key === "correct") {
          this.sub_mode = "correct_mode"
          this.delay(CORRECT_MODE_DELAY, () => {
            this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
          })
        } else {
          this.sub_mode = "mistake_mode"
          this.delay(MISTAKE_MODE_DELAY, () => {
            this.$ac_room.perform("goal_hook") // --> app/channels/actb/room_channel.rb
          })
        }
      }
    },

    ox_sound_play(ans_result_key) {
      if (ans_result_key === "correct") {
        this.sound_play("pipopipo")
      } else {
        this.sound_play("bubuu")
      }
    },
  },

  computed: {
    current_membership() {
      if (this.room) {
        return this.room.memberships.find(e => e.user.id === this.current_user.id)
      }
    },
    current_best_question() {
      if (this.room) {
        return this.room.best_questions[this.question_index]
      }
    },
    current_best_question_size() {
      if (this.room) {
        return this.room.best_questions.length
      }
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
  },
}
