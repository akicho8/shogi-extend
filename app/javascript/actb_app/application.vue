<template lang="pug">
.actb_app(:class="mode")
  the_profile_edit( v-if="mode === 'profile_edit'")
  the_lobby(        v-if="mode === 'lobby'")
  the_rule_select(  v-if="mode === 'rule_select'")
  the_matching(     v-if="mode === 'matching'")
  the_battle(       v-if="mode === 'battle'")
  the_result(       v-if="mode === 'result'")

  the_ranking(      v-if="mode === 'ranking'")
  the_history(      v-if="mode === 'history'")
  the_builder(      v-if="mode === 'builder'")
  the_menu(         v-if="mode === 'menu'")

  details(v-if="app.debug_mode_p")
    summary DEBUG
    debug_print( :grep="/./")

  template(v-if="development_p")
    router-link(to="/training/menu") menu
    router-view
</template>

<script>
import { support } from "./support.js"
import { store   } from "./store.js"

import { the_question_show_mod } from "./the_question_show_mod.js"
import { the_user_show_mod }     from "./the_user_show_mod.js"

// Page Components
import the_question_show from "./the_question_show.vue"
import the_user_show     from "./the_user_show.vue"
import the_lobby         from "./the_lobby.vue"
import the_rule_select   from "./the_rule_select.vue"
import the_profile_edit  from "./the_profile_edit.vue"
import the_matching      from "./the_matching.vue"
import the_battle        from "./the_battle/the_battle.vue"
import the_result        from "./the_result.vue"
import the_builder       from "./the_builder/the_builder.vue"
import the_ranking       from "./the_ranking.vue"
import the_history       from "./the_history/the_history.vue"
import the_menu          from "./the_menu.vue"

// Mixins
import { application_room         } from "./application_room.js"
import { application_battle       } from "./application_battle.js"
import { application_matching     } from "./application_matching.js"
import { application_history      } from "./application_history.js"
import { application_history_vote } from "./application_history_vote.js"
import { config                   } from "./config.js"
import { RuleInfo                 } from "./models/rule_info.js"
import { OxMarkInfo               } from "./models/ox_mark_info.js"
import { SkillInfo               } from "./models/skill_info.js"

export default {
  store,
  name: "actb_app",
  mixins: [
    support,
    config,

    the_question_show_mod,
    the_user_show_mod,

    application_room,
    application_battle,
    application_matching,
    application_history_vote,

    application_history,
  ],
  components: {
    the_question_show,
    the_user_show,
    the_lobby,
    the_rule_select,
    the_profile_edit,
    the_matching,
    the_battle,
    the_result,
    the_builder,
    the_ranking,
    the_history,
    the_menu,
  },
  props: {
    info: { required: true },
  },

  data() {
    return {
      current_user: this.info.current_user,

      mode: null,
      sub_mode: null,
      rule_key: null,           // 未使用
      room: null,

      matching_list_hash:   null, // 対戦待ちの人のIDを列挙している
      online_user_ids: null, // オンライン人数
      room_user_ids:   null, // オンライン人数

      // チャット用
      lobby_messages: null, // メッセージ(複数)
      lobby_message_body:  null, // 入力中のメッセージ

      RuleInfo: null,
      OxMarkInfo: null,
      SkillInfo: null,

      menu_component: null,

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
    this.remote_get(this.app.info.api_path, { remote_action: "resource_fetch" }, e => {
      this.RuleInfo   = RuleInfo.memory_record_reset(e.RuleInfo)
      this.OxMarkInfo = OxMarkInfo.memory_record_reset(e.OxMarkInfo)
      this.SkillInfo = SkillInfo.memory_record_reset(e.SkillInfo)
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
        this.talk2(message.body)
        this.$buefy.toast.open({message: `${message.user.name}: ${message.body}`, position: "is-top", queue: false})
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    school_setup() {
      this.__assert__(this.$ac_school == null, "this.$ac_school == null")
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

      this.lobby_messages_setup()

      this.debug_alert("lobby_setup")
      this.__assert__(this.$ac_lobby == null, "this.$ac_lobby == null")
      this.$ac_lobby = this.ac_subscription_create({channel: "Actb::LobbyChannel"})

      this.after_lobby_setup()
    },

    after_lobby_setup() {
      const id = this.$route.query.question_id
      if (id) {
        this.ov_question_info_set(id)
      }
    },

    lobby_messages_setup() {
      this.lobby_messages = []
      this.lobby_message_body = ""
      this.remote_get(this.app.info.api_path, { remote_action: "lobby_messages_fetch" }, e => {
        this.lobby_messages = e.lobby_messages
      })
    },

    debug_matching_add_handle(rule_key) {
      this.remote_fetch("PUT", this.app.info.api_path, {remote_action: "debug_matching_add_handle", exclude_user_id: this.current_user.id, rule_key: rule_key}, e => {})
    },

    matching_delete_all_handle() {
      this.remote_fetch("PUT", this.app.info.api_path, { remote_action: "matching_delete_all_handle", exclude_user_id: this.current_user.id }, e => {})
    },

    start_handle() {
      this.sound_play("click")
      if (this.login_required2()) { return }

      this.mode = "rule_select"
      this.talk2("ルールを選択してください")
    },

    rule_key_set_handle(rule) {
      this.sound_play("click")
      this.talk2(rule.name)
      this.remote_fetch("PUT", this.app.info.api_path, { remote_action: "rule_key_set_handle", rule_key: rule.key }, e => {
        this.matching_setup()
      })
    },

    // ロビー → ルール選択 →●ロビー
    rule_cancel_handle() {
      this.sound_play("click")
      this.mode = "lobby"
    },

    // ロビー → ルール選択 → マッチング開始 →●ルール選択
    matching_cancel_handle() {
      this.sound_play("click")

      this.app.matching_interval_timer_clear()

      this.__assert__(this.$ac_lobby, "this.$ac_lobby")
      this.$ac_lobby.perform("matching_cancel")

      this.mode = "rule_select"
    },

    ////////////////////////////////////////////////////////////////////////////////

    // メニュー内の切り替え
    menu_to(v) {
      this.sound_play("click")
      this.app.menu_component = v
    },

    ////////////////////////////////////////////////////////////////////////////////

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

    menu_handle() {
      if (this.mode === "menu") {
        if (this.menu_component === "the_menu_root") {
        } else {
          this.menu_to("the_menu_root")
        }
      } else {
        this.mode = "menu"
      }
    },
  },

  computed: {
    // current_user() {
    //   return this.info.current_user
    // },

    // いったんスクリプトに飛ばしているのは sessions[:return_to] を設定するため
    login_path() {
      const url = new URL(location)
      url.searchParams.set("goto_login", true)
      return url.toString()
    },

    debug_mode_p() {
      if (this.current_user) {
        // return this.current_user.key === "sysop" || this.current_user.name === "きなこもち" || this.current_user.name === "わらびもち"
        return this.current_user.key === "sysop"
      }
    },
    user_type() {
      if (this.current_user) {
        if (this.current_user.key === "sysop") {
          return "admin"
        } else {
          return "general"
        }
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
