<template lang="pug">
.actf_app(:class="mode")
  the_header
  the_footer
  the_lobby(:info="info" v-if="mode === 'lobby'")
  the_lobby_message(:info="info" v-if="mode === 'lobby'")
  the_matching(:info="info" v-if="mode === 'matching'")
  the_room(:info="info" v-if="mode === 'room'")
  the_room_message(:info="info" v-if="mode === 'room'")
  the_result(:info="info" v-if="mode === 'result'")
  the_room_message(:info="info" v-if="mode === 'result'")
  the_builder(:info="info" v-if="mode === 'edit'")
  the_ranking(v-if="mode === 'ranking'")
  debug_print(:grep="/./")
</template>

<script>
const WAIT_SECOND = 1.5

import consumer from "channels/consumer"

import the_support from './the_support'
import the_store   from './the_store'

import the_header     from './the_header'
import the_footer     from './the_footer'
import the_lobby      from './the_lobby'
import the_lobby_message from './the_lobby_message'
import the_matching   from './the_matching'
import the_room       from './the_room'
import the_room_message  from './the_room_message'
import the_result     from './the_result'
import the_builder    from './the_builder'
import the_ranking    from './the_ranking'

export default {
  store: the_store,
  name: "actf_app",
  mixins: [
    the_support,
  ],
  components: {
    the_header,
    the_footer,
    the_lobby,
    the_lobby_message,
    the_matching,
    the_room,
    the_room_message,
    the_result,
    the_builder,
    the_ranking,
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: "lobby",
      room: this.info.room,

      matching_list:   null, // 対戦待ちの人のIDを列挙している
      online_user_ids: null, // オンライン人数
      room_user_ids:   null, // オンライン人数
      quest_index:     null, // 正解中の問題インデックス
      freeze_mode:     null, // 正解直後に間を開けているとき true になっている
      progress_info:   null, // 各 membership_id はどこまで進んでいるかわかる {"1" => 2, "3" => 4}

      // チャット用
      room_messages: null, // メッセージ(複数)
      room_message:  null, // 入力中のメッセージ

      // チャット用
      lobby_messages: null, // メッセージ(複数)
      lobby_message:  null, // 入力中のメッセージ

      // private
      $school: null, // --> app/channels/actf/school_channel.rb
      $lobby:  null, // --> app/channels/actf/lobby_channel.rb
      $room:   null, // --> app/channels/actf/room_channel.rb
    }
  },

  created() {
    this.main_nav_set(false)

    this.school_setup()

    if (this.info.debug_scene === "room") {
      this.mode = "room"
      this.room_setup()
    }

    if (this.info.debug_scene === "result") {
      this.mode = "result"
    }

    if (this.info.debug_scene === "edit") {
      this.goto_edit_mode_handle()
    }

    if (this.info.debug_scene === "ranking") {
      this.mode = "ranking"
    }

    if (this.mode === "lobby") {
      this.lobby_setup()
    }
  },

  beforeCreate() {
    this.$store.state.app = this
  },

  watch: {
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    lobby_speak_handle() {
      this.lobby_speak(this.lobby_message)
      this.lobby_message = ""
    },

    lobby_speak(message) {
      this.$lobby.perform("speak", {message: message})
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_speak_handle() {
      this.room_speak(this.room_message)
      this.room_message = ""
    },

    room_speak(message) {
      this.$room.perform("speak", {message: message})
    },

    ////////////////////////////////////////////////////////////////////////////////

    school_setup() {
      this.$school = consumer.subscriptions.create({channel: "Actf::SchoolChannel"}, {
        connected: () => {
          this.debug_alert("school 接続")
        },
        disconnected: () => {
          this.debug_alert("school 切断")
        },
        received: (data) => {
          if (data.online_user_ids) {
            this.online_user_ids = data.online_user_ids
          }
          if (data.room_user_ids) {
            this.room_user_ids = data.room_user_ids
          }
          this.ac_info_update()
        },
      })
    },

    lobby_setup() {
      this.lobby_messages = []
      this.lobby_message = ""

      this.debug_alert("lobby_setup")
      this.__assert(this.$lobby == null)
      this.$lobby = consumer.subscriptions.create({channel: "Actf::LobbyChannel"}, {
        connected: () => {
          this.debug_alert("lobby 接続")
        },
        disconnected: () => {
          this.debug_alert("lobby 切断")
        },
        received: (data) => {
          this.debug_alert("lobby 受信")

          console.log(data)

          // チャット
          if (data.messages) {
            this.lobby_messages = data.messages
          }

          if (data.message) {
            const message = data.message

            this.$buefy.toast.open({message: `${message.user.name}: ${message.body}`, position: "is-top", queue: false})
            this.talk(message.body, {rate: 1.5})

            this.lobby_messages.push(message)
          }

          // マッチング待ち
          if (data.matching_list) {
            console.log(data.matching_list)
            this.matching_list = data.matching_list
          }

          // マッチング成立
          if (data.room) {
            const membership = data.room.memberships.find(e => e.user.id === this.current_user.id)
            if (membership) {
              this.lobby_unsubscribe()
              //- this.interval_timer_clear()

              this.room = data.room
              this.room_setup()
            }
          }
        },
      })
    },

    start_handle() {
      if (this.login_required2()) { return }

      this.sound_play("click")
      this.mode = "matching"
    },

    cancel_handle() {
      this.sound_play("click")
      this.mode = "lobby"
      this.$lobby.perform("matching_cancel")
    },

    room_setup() {
      this.mode = "room"

      this.room_messages = []
      this.room_message = ""

      this.freeze_mode = false
      this.progress_info = {}

      this.quest_index = 0
      this.sound_play("deden")

      this.__assert(this.$room == null)
      this.$room = consumer.subscriptions.create({ channel: "Actf::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.debug_alert("room 接続")
        },
        disconnected: () => {
          alert("room disconnected")
          this.debug_alert("room 切断")
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
          if (data.progress_info_share) {
            const e = data.progress_info_share
            this.$set(this.progress_info, e.membership_id, e.quest_index)
            if (e.membership_id !== this.current_membership.id) {
              this.sound_play("pipopipo")
            }
          }

          // 終了
          if (data.switch_to === "result") {
            this.mode = "result"
            this.room = data.room
            if (this.current_membership) {
              if (this.current_membership.judge_key === "win") {
                this.sound_play("win")
              }
              if (this.current_membership.judge_key === "lose") {
                this.sound_play("lose")
              }
            }
          }
        },
      })
    },

    lobby_button_handle() {
      this.sound_play("click")

      this.room_unsubscribe()

      this.mode = "lobby"
      this.lobby_setup()
    },

    play_mode_advanced_full_moves_sfen_set(long_sfen) {
      if (this.freeze_mode) {
        return
      }

      if (this.current_quest_answers.includes(this.position_sfen_remove(long_sfen))) {
        // 正解
        this.sound_play("pipopipo")
        this.$room.perform("progress_info_share", {
          membership_id: this.current_membership.id,
          quest_index: this.quest_index + 1,
          quest_id: this.current_quest_id, // 問題ID
        }) // --> app/channels/actf/room_channel.rb

        this.freeze_mode = true
        setTimeout(() => {
          this.quest_index += 1
          if (this.quest_index >= this.current_simple_quest_info_size) {
            this.$room.perform("katimasitayo") // --> app/channels/actf/room_channel.rb
          } else {
            this.sound_play("deden")
            this.freeze_mode = false
          }
        }, 1000 * WAIT_SECOND)

      }
      // if (long_sfen === "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1 moves G*5b") {
      //   this.$room.perform("katimasitayo") // --> app/channels/actf/room_channel.rb
      // }
    },

    quest_index_for(membership) {
      if (this.progress_info) {
        return this.progress_info[membership.id] || 0
      }
    },

    login_required2() {
      if (!this.current_user) {
        this.url_open(this.login_path)
        return true
        // this.url_open("/xusers/sign_in")
      }
    },

    lobby_unsubscribe() {
      if (this.$lobby) {
        this.$lobby.unsubscribe()
        this.$lobby = null
        this.ac_info_update()
      }
    },

    room_unsubscribe() {
      if (this.$room) {
        this.$room.unsubscribe()
        this.$room = null
        this.ac_info_update()
      }
    },

    goto_edit_mode_handle() {
      this.sound_play("click")

      this.lobby_unsubscribe()

      this.mode = "edit"
    },

    ranking_handle() {
      this.mode = "ranking"
    },
  },

  computed: {
    current_user() {
      return this.info.current_user
    },
    current_membership() {
      if (this.room) {
        return this.room.memberships.find(e => e.user.id === this.current_user.id)
      }
    },
    current_simple_quest_info() {
      if (this.room) {
        return this.room.simple_quest_infos[this.quest_index]
      }
    },
    current_simple_quest_info_size() {
      if (this.room) {
        return this.room.simple_quest_infos.length
      }
    },
    current_quest_init_sfen() {
      const info = this.current_simple_quest_info
      if (info) {
        return info.init_sfen
      }
    },
    current_quest_answers() {
      const info = this.current_simple_quest_info
      if (info) {
        return info.moves_answers.map(e => [info.init_sfen, "moves", e.moves_str].join(" "))
      }
    },
    current_quest_id() {
      const info = this.current_simple_quest_info
      if (info) {
        return info.id
      }
    },

    // いったんスクリプトに飛ばしているのは sessions[:return_to] を設定するため
    login_path() {
      const url = new URL(location)
      url.searchParams.set("login_required", true)
      return url.toString()
    },

  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.actf_app
  // ユーザー情報
  .user_container
    flex-direction: column
    justify-content: flex-end
    align-items: center

    // アイコンの上の勝敗メッセージ
    .icon_up_message

    // アイコン
    figure
      margin-top: 0.5rem

    // ユーザー名
    .user_name
      margin-top: 0.5rem
      font-size: $size-7

    .user_rating_diff
      margin-left: 0.25rem
</style>
