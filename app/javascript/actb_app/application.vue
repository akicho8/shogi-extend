<template lang="pug">
.actb_app(:class="mode")
  the_question_show(v-if="overlay_record")

  .switching_pages(v-show="!overlay_record")
    the_footer(v-if="mode === 'lobby' || mode === 'ranking' || mode === 'history' || mode === 'builder'")
    the_system_header(v-if="mode === 'lobby' || mode === 'matching'")
    the_lobby(:info="info" v-if="mode === 'lobby'")
    the_lobby_message(:info="info" v-if="mode === 'lobby'")
    the_matching(:info="info" v-if="mode === 'matching'")
    the_room(:info="info" v-if="mode === 'room'")
    the_room_message(:info="info" v-if="mode === 'room'")
    the_result(:info="info" v-if="mode === 'result'")
    the_room_message(:info="info" v-if="mode === 'result'")
    the_builder(:info="info" v-if="mode === 'builder'")
    the_ranking(v-if="mode === 'ranking'")
    the_history(v-if="mode === 'history'")

  debug_print(:grep="/./")
</template>

<script>
import consumer from "channels/consumer"

import support   from "./support.js"
import the_store from "./store.js"

import the_question_show_mod from "./the_question_show_mod.js"

import the_question_show from "./the_question_show.vue"
import the_system_header    from "./the_system_header.vue"
import the_footer           from "./the_footer.vue"
import the_lobby            from "./the_lobby.vue"
import the_lobby_message    from "./the_lobby_message.vue"
import the_matching         from "./the_matching.vue"
import the_room             from "./the_room.vue"
import the_room_message     from "./the_room_message.vue"
import the_result           from "./the_result.vue"
import the_builder          from "./the_builder.vue"
import the_ranking          from "./the_ranking.vue"
import the_history          from "./the_history.vue"

import { application_room     } from "./application_room.js"
import { application_matching } from "./application_matching.js"
import { config               } from "./config.js"
import { RuleInfo             } from "./rule_info.js"

export default {
  store: the_store,
  name: "actb_app",
  mixins: [
    support,
    config,

    the_question_show_mod,

    application_room,
    application_matching,
  ],
  components: {
    the_question_show,
    the_system_header,
    the_footer,
    the_lobby,
    the_lobby_message,
    the_matching,
    the_room,
    the_room_message,
    the_result,
    the_builder,
    the_ranking,
    the_history,
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
      mode: "lobby",
      sub_mode: "opening",
      rule_key: null,           // 未使用
      room: null,

      matching_list_hash:   null, // 対戦待ちの人のIDを列挙している
      online_user_ids: null, // オンライン人数
      room_user_ids:   null, // オンライン人数

      // チャット用
      room_messages: null, // メッセージ(複数)
      room_message:  null, // 入力中のメッセージ

      // チャット用
      lobby_messages: null, // メッセージ(複数)
      lobby_message:  null, // 入力中のメッセージ

      // private
      // $ac_school: null, // --> app/channels/actb/school_channel.rb
      // $ac_lobby:  null, // --> app/channels/actb/lobby_channel.rb
      // $ac_room:   null, // --> app/channels/actb/room_channel.rb
    }
  },

  beforeCreate() {
    this.$store.state.app = this
  },

  created() {
    this.http_get_command(this.app.info.put_path, { remote_action: "resource_fetch" }, e => {
      this.$RuleInfo = RuleInfo.memory_record_reset(e.RuleInfo)
      this.app_setup()
    })
  },

  methods: {
    app_setup() {
      this.school_setup()

      if (this.info.debug_scene) {
        if (this.info.debug_scene === "room_marathon_rule") {
          // this.rule_key = "marathon_rule"
          this.room_setup(this.info.room)
        }
        if (this.info.debug_scene === "room_singleton_rule") {
          // this.rule_key = "singleton_rule"
          this.room_setup(this.info.room)
        }
        if (this.info.debug_scene === "result") {
          this.mode = "result"
        }
        if (this.info.debug_scene === "builder" || this.info.debug_scene === "builder_form") {
          this.builder_handle()
        }
        if (this.info.debug_scene === "ranking") {
          this.ranking_handle()
        }
        if (this.info.debug_scene === "history") {
          this.history_handle()
        }
        if (this.info.debug_scene === "overlay_record") {
          this.overlay_record_set(this.info.question_id)
        }
      }

      if (this.mode === "lobby") {
        this.lobby_setup()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // // lobbyに接続した瞬間に送られてくる
    // lobby_messages_broadcasted(params) {
    //   this.lobby_messages = params.messages
    // },

    lobby_speak_handle() {
      this.lobby_speak(this.lobby_message)
      this.lobby_message = ""
    },

    lobby_speak(message) {
      this.$ac_lobby.perform("speak", {message: message})
    },
    lobby_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.lobby_messages.push(params.message)
    },

    // room_speak_broadcasted と共有
    lobby_speak_broadcasted_shared_process(params) {
      const message = params.message
      if (/^\*/.test(message.body)) {
      } else {
        this.talk(message.body, {rate: 1.5})
        this.$buefy.toast.open({message: `${message.user.name}: ${message.body}`, position: "is-top", queue: false})
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    school_setup() {
      this.$ac_school = consumer.subscriptions.create({channel: "Actb::SchoolChannel"}, {
        connected: () => {
          this.debug_alert("school 接続")
          this.ac_info_update()
        },
        disconnected: () => {
          this.debug_alert("school 切断")
          this.ac_info_update()
        },
        received: (data) => {
          if (data.online_user_ids) {
            this.online_user_ids = data.online_user_ids
          }
          if (data.room_user_ids) {
            this.room_user_ids = data.room_user_ids
          }
        },
      })
    },

    lobby_setup() {
      this.lobby_messages_setup()

      this.debug_alert("lobby_setup")
      this.__assert(this.$ac_lobby == null)
      this.$ac_lobby = consumer.subscriptions.create({channel: "Actb::LobbyChannel"}, {
        connected: () => {
          this.debug_alert("lobby 接続")
          this.ac_info_update()
        },
        disconnected: () => {
          this.debug_alert("lobby 切断")
          this.ac_info_update()
        },
        received: (data) => {
          if (data.bc_action) {
            this[data.bc_action](data.bc_params)
          }
        },
      })
    },

    lobby_messages_setup() {
      this.lobby_messages = []
      this.lobby_message = ""
      this.http_get_command(this.app.info.put_path, { remote_action: "lobby_messages_fetch" }, e => {
        this.lobby_messages = e.lobby_messages
      })
    },

    rule_key_select_handle() {
      this.sound_play("click")
      if (this.login_required2()) { return }

      this.sub_mode = "rule_key_select"
    },

    rule_key_set_handle(rule_key) {
      this.sound_play("click")

      // this.rule_key = rule_key  // これセットする意味ないか？
      this.lobby_speak(`*rule_key_set_handle("${rule_key}")`)
      this.http_get_command(this.app.info.put_path, { remote_action: "rule_key_set_handle", rule_key: rule_key }, e => {
        this.lobby_speak(`*rule_key_set_handle -> ${e}`)
        this.mode = "matching"
      })
    },

    cancel_handle() {
      this.sound_play("click")
      this.mode = "lobby"
      this.$ac_lobby.perform("matching_cancel")
    },

    lobby_handle() {
      if (this.mode === "lobby") {
      } else {
        this.sound_play("click")

        this.room_unsubscribe()

        this.mode = "lobby"
        this.lobby_setup()
      }
    },

    login_required2() {
      if (!this.current_user) {
        this.url_open(this.login_path)
        return true
        // this.url_open("/xusers/sign_in")
      }
    },

    lobby_close() {
      if (this.$ac_lobby) {
        this.$ac_lobby.unsubscribe()
        this.$ac_lobby = null
        this.ac_info_update()
      }
    },

    builder_handle() {
      if (this.mode === "builder") {
      } else {
        this.mode = "builder"
      }
    },

    ranking_handle() {
      if (this.mode === "ranking") {
      } else {
        this.mode = "ranking"
      }
    },

    history_handle() {
      if (this.mode === "history") {
      } else {
        this.mode = "history"
      }
    },

    vote_handle(history, vote_key, vote_value) {
      this.sound_play("click")
      if (vote_key === "good") {
        if (vote_value) {
          this.talk("よき", {rate: 1.5})
        }
      } else {
        if (vote_value) {
          this.talk("だめ", {rate: 1.5})
        }
      }
      this.silent_http_command("PUT", this.app.info.put_path, { vote_handle: true, question_id: history.question.id, vote_key: vote_key, vote_value: vote_value, }, e => {
        if (e.retval) {
          this.$set(history, "good_p", e.retval.good_p)
          this.$set(history.question, "good_marks_count", history.question.good_marks_count + e.retval.good_diff)

          this.$set(history, "bad_p", e.retval.bad_p)
          this.$set(history.question, "bad_marks_count", history.question.bad_marks_count + e.retval.bad_diff)
        }
      })
    },

    clip_handle(history, clip_p) {
      this.sound_play("click")
      if (clip_p) {
        this.talk("お気に入り", {rate: 1.5})
      }
      this.silent_http_command("PUT", this.app.info.put_path, { clip_handle: true, question_id: history.question.id, clip_p: clip_p, }, e => {
        if (e.retval) {
          this.$set(history, "clip_p", e.retval.clip_p)
          this.$set(history.question, "clip_marks_count", history.question.clip_marks_count + e.retval.diff)
        }
      })
    },
  },

  computed: {
    current_user() {
      return this.info.current_user
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
@import "support.sass"
@import "application.sass"
.actb_app
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
