<template lang="pug">
.actb_app(:class="mode")
  the_question_show(v-if="ov_question_info")
  the_user_show(v-if="ov_user_info")

  .switching_pages(v-show="!ov_question_info && !ov_user_info")
    the_footer(v-if="mode === 'lobby' || mode === 'ranking' || mode === 'history' || mode === 'builder'")
    the_system_header(v-if="mode === 'lobby' && sub_mode === 'opening'")
    the_lobby(v-if="mode === 'lobby'")
    the_lobby_message(v-if="mode === 'lobby'")
    the_profile_edit(v-if="mode === 'profile_edit'")
    the_matching(v-if="mode === 'matching'")
    the_battle(v-if="mode === 'battle'")
    the_room_message(v-if="mode === 'battle'")
    the_result(v-if="mode === 'result'")
    the_room_message(v-if="mode === 'result'")
    the_builder(v-if="mode === 'builder'")
    the_ranking(v-if="mode === 'ranking'")
    the_history(v-if="mode === 'history'")

  debug_print(v-if="app.debug_mode_p" :grep="/./")
</template>

<script>
import { support } from "./support.js"
import { store   } from "./store.js"

import { the_question_show_mod } from "./the_question_show_mod.js"
import { the_user_show_mod } from "./the_user_show_mod.js"

import the_question_show from "./the_question_show.vue"
import the_user_show from "./the_user_show.vue"
import the_system_header from "./the_system_header.vue"
import the_footer        from "./the_footer.vue"
import the_lobby         from "./the_lobby.vue"
import the_lobby_message from "./the_lobby_message.vue"
import the_profile_edit         from "./the_profile_edit.vue"
import the_matching      from "./the_matching.vue"
import the_battle          from "./the_battle/the_battle.vue"
import the_room_message  from "./the_room_message.vue"
import the_result        from "./the_result.vue"
import the_builder       from "./the_builder/the_builder.vue"
import the_ranking       from "./the_ranking.vue"
import the_history       from "./the_history/the_history.vue"

import { application_room     } from "./application_room.js"
import { application_battle     } from "./application_battle.js"
import { application_matching } from "./application_matching.js"
import { config               } from "./config.js"
import { RuleInfo             } from "./models/rule_info.js"
import { OxMarkInfo        } from "./models/ox_mark_info.js"

export default {
  store: store,
  name: "actb_app",
  mixins: [
    support,
    config,

    the_question_show_mod,
    the_user_show_mod,

    application_room,
    application_battle,
    application_matching,
  ],
  components: {
    the_question_show,
    the_user_show,
    the_system_header,
    the_footer,
    the_lobby,
    the_lobby_message,
    the_profile_edit,
    the_matching,
    the_battle,
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
      current_user: this.info.current_user,

      mode: null,
      sub_mode: "opening",
      rule_key: null,           // 未使用
      room: null,
      battle: null,

      matching_list_hash:   null, // 対戦待ちの人のIDを列挙している
      online_user_ids: null, // オンライン人数
      room_user_ids:   null, // オンライン人数

      // チャット用
      lobby_messages: null, // メッセージ(複数)
      lobby_message_body:  null, // 入力中のメッセージ

      RuleInfo: null,
      OxMarkInfo: null,

      // リアクティブではないもの
      // $ac_school: null, // --> app/channels/actb/school_channel.rb
      // $ac_lobby:  null, // --> app/channels/actb/lobby_channel.rb
      // $ac_room:   null, // --> app/channels/actb/room_channel.rb
      // $ac_battle: null, // --> app/channels/actb/battle_channel.rb
    }
  },

  beforeCreate() {
    this.$store.state.app = this
  },

  created() {
    this.remote_get(this.app.info.put_path, { remote_action: "resource_fetch" }, e => {
      this.RuleInfo   = RuleInfo.memory_record_reset(e.RuleInfo)
      this.OxMarkInfo = OxMarkInfo.memory_record_reset(e.OxMarkInfo)
      this.app_setup()
    })
  },

  methods: {
    app_setup() {
      this.school_setup()

      if (this.info.debug_scene) {
        if (this.info.debug_scene === "profile_edit" || this.info.debug_scene === "profile_edit_image_crop") {
          this.profile_edit_setup()
        }
        if (this.info.debug_scene === "battle_marathon_rule" || this.info.debug_scene === "battle_singleton_rule" || this.info.debug_scene === "battle_hybrid_rule") {
          this.room_setup(this.info.room)
        }
        if (this.info.debug_scene === "result") {
          this.room_setup(this.info.room)
        }
        if (this.info.debug_scene === "builder" || this.info.debug_scene === "builder_haiti" || this.info.debug_scene === "builder_form") {
          this.builder_handle()
        }
        if (this.info.debug_scene === "ranking") {
          this.ranking_handle()
        }
        if (this.info.debug_scene === "history") {
          this.history_handle()
        }
        if (this.info.debug_scene === "ov_question_info") {
          this.ov_question_info_set(this.info.question_id)
        }
        if (this.info.debug_scene === "ov_user_info") {
          this.ov_user_info_set(this.info.current_user.id)
        }
      } else {
        this.lobby_setup()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // // lobbyに接続した瞬間に送られてくる
    // lobby_messages_broadcasted(params) {
    //   this.lobby_messages = params.messages
    // },

    lobby_speak_handle() {
      this.lobby_speak(this.lobby_message_body)
      this.lobby_message_body = ""
    },

    lobby_speak(message_body) {
      this.$ac_lobby.perform("speak", {message_body: message_body})
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
      this.__assert__(this.$ac_school == null)
      this.$ac_school = this.ac_subscription_create({channel: "Actb::SchoolChannel"})
    },
    online_status_broadcasted(params) {
      if (params.online_user_ids) {
        this.online_user_ids = params.online_user_ids
      }
      if (params.room_user_ids) {
        this.room_user_ids = params.room_user_ids
      }
    },

    profile_edit_setup() {
      this.lobby_unsubscribe()
      this.mode = "profile_edit"
    },

    lobby_setup() {
      this.battle_unsubscribe()
      this.room_unsubscribe()

      this.mode = "lobby"
      this.sub_mode = "opening"

      this.lobby_messages_setup()

      this.debug_alert("lobby_setup")
      this.__assert__(this.$ac_lobby == null)
      this.$ac_lobby = this.ac_subscription_create({channel: "Actb::LobbyChannel"})
    },

    lobby_messages_setup() {
      this.lobby_messages = []
      this.lobby_message_body = ""
      this.remote_get(this.app.info.put_path, { remote_action: "lobby_messages_fetch" }, e => {
        this.lobby_messages = e.lobby_messages
      })
    },

    debug_matching_add_handle(rule_key) {
      this.remote_fetch("PUT", this.app.info.put_path, {remote_action: "debug_matching_add_handle", exclude_user_id: this.current_user.id, rule_key: rule_key}, e => {})
    },

    matching_delete_all_handle() {
      this.remote_fetch("PUT", this.app.info.put_path, { remote_action: "matching_delete_all_handle", exclude_user_id: this.current_user.id }, e => {})
    },

    rule_key_select_handle() {
      this.sound_play("click")
      if (this.login_required2()) { return }

      this.sub_mode = "rule_key_select"
    },

    rule_key_set_handle(rule_key) {
      this.sound_play("click")
      this.remote_get(this.app.info.put_path, { remote_action: "rule_key_set_handle", rule_key: rule_key }, e => {
        this.matching_setup()
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
        this.lobby_setup()
      }
    },

    profile_edit_handle() {
      if (this.mode === "profile_edit") {
      } else {
        this.sound_play("click")
        this.profile_edit_setup()
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
      this.ac_unsubscribe("$ac_lobby")
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

    vote_handle(history, vote_key, enabled) {
      this.sound_play("click")
      // enabled: enabled → その値に設定
      // enabled: null       → トグルする
      this.silent_remote_fetch("PUT", this.app.info.put_path, { remote_action: "vote_handle", question_id: history.question.id, vote_key: vote_key, enabled: null, }, e => {
        if (e.good.diff >= 1) {
          this.talk("よき", {rate: 1.5})
        }
        this.$set(history, "good_p", e.good.enabled)
        this.$set(history.question, "good_marks_count", history.question.good_marks_count + e.good.diff)

        if (e.bad.diff >= 1) {
          this.talk("だめ", {rate: 1.5})
        }
        this.$set(history, "bad_p", e.bad.enabled)
        this.$set(history.question, "bad_marks_count", history.question.bad_marks_count + e.bad.diff)
      })
    },

    clip_handle(history, enabled) {
      this.sound_play("click")
      this.silent_remote_fetch("PUT", this.app.info.put_path, { remote_action: "clip_handle", question_id: history.question.id, enabled: null, }, e => {
        if (e.diff >= 1) {
          this.talk("保存リストに追加しました", {rate: 1.5})
        }
        this.$set(history, "clip_p", e.enabled)
        this.$set(history.question, "clip_marks_count", history.question.clip_marks_count + e.diff)
      })
    },
  },

  computed: {
    // current_user() {
    //   return this.info.current_user
    // },

    // いったんスクリプトに飛ばしているのは sessions[:return_to] を設定するため
    login_path() {
      const url = new URL(location)
      url.searchParams.set("login_required", true)
      return url.toString()
    },

    debug_mode_p() {
      if (this.current_user) {
        return this.current_user.key === "sysop"
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "application.sass"
.actb_app
</style>
