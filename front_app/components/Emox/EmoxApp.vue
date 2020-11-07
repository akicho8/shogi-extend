<template lang="pug">
.EmoxApp(:class="mode")
  EmoxLobby(:base="base"      v-if="mode === 'lobby'")
  EmoxRuleSelect(:base="base" v-if="mode === 'rule_select'")
  EmoxMatching(:base="base"   v-if="mode === 'matching'")
  EmoxBattle(:base="base"     v-if="mode === 'battle'")
  EmoxResult(:base="base"     v-if="mode === 'result'")

  DebugPrint(:grep="/./" v-if="development_p")
</template>

<script>
import { support } from "./support.js"

// Mixins
import { application_room     } from "./application_room.js"
import { application_emotion  } from "./application_emotion.js"
import { application_battle   } from "./application_battle.js"
import { application_matching } from "./application_matching.js"

import { RuleInfo             } from "./models/rule_info.js"
import { EmotionInfo          } from "./models/emotion_info.js"

export default {
  name: "EmoxApp",
  mixins: [
    support,
    application_room,
    application_emotion,
    application_battle,
    application_matching,
  ],
  data() {
    return {
      info: null,

      mode: "lobby",
      sub_mode: null,

      school_user_ids:        null, // オンラインのユーザーIDs
      room_user_ids:          null, // 対戦中のユーザーIDs
      matching_user_ids_hash: null, // 対戦待ちユーザーIDsのハッシュでルール名がキー

      // リソース
      RuleInfo:   null,
      EmotionInfo: null,

      // メニュー用
      menu_component: null,

      // 引数に画面遷移の指定があるとき何度も遷移してしまうのを伏せぐため
      redirect_counter: 0,

      // リアクティブではないもの
      // $ac_school: null, // --> app/channels/emox/school_channel.rb
      // $ac_lobby:  null, // --> app/channels/emox/lobby_channel.rb
      // $ac_room:   null, // --> app/channels/emox/room_channel.rb
      // $ac_battle: null, // --> app/channels/emox/battle_channel.rb
    }
  },

  fetchOnServer: false,
  fetch() {
    // http://0.0.0.0:3000/api/emox/resource_fetch.json
    return this.$axios.$get("/api/emox/resource_fetch.json", {params: this.$route.query}).then(e => {
      this.info        = e
      this.RuleInfo    = RuleInfo.memory_record_reset(e.RuleInfo)
      this.EmotionInfo = EmotionInfo.memory_record_reset(e.EmotionInfo)
    })
  },

  beforeDestroy() {
    this.lobby_unsubscribe()
    this.school_unsubscribe()
    this.room_unsubscribe()
    this.battle_unsubscribe()
  },

  mounted() {
    this.ga_click("エモ将棋")
    this.school_setup()
    this.lobby_setup()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    school_setup() {
      this.__assert__(this.$ac_school == null, "this.$ac_school == null")
      this.$ac_school = this.ac_subscription_create({channel: "Emox::SchoolChannel"})
    },
    school_unsubscribe() {
      this.ac_unsubscribe("$ac_school")
    },

    active_users_status_broadcasted(params) {
      if (params.emox_school_user_ids) {
        this.school_user_ids = params.emox_school_user_ids
      }
      if (params.emox_room_user_ids) {
        this.room_user_ids = params.emox_room_user_ids
      }
    },

    lobby_setup_without_cable() {
      this.battle_unsubscribe()
      this.room_unsubscribe()

      this.mode = "lobby"
      this.room = null          // 対戦中ではないことを判定するため消しておく
    },

    lobby_setup() {
      this.lobby_setup_without_cable()

      this.__assert__(this.$ac_lobby == null, "ロビーが解放されてないのに再び接続しようとしている")
      this.$ac_lobby = this.ac_subscription_create({channel: "Emox::LobbyChannel"})
    },

    debug_matching_add_handle(rule) {
      this.$axios.$put("/api/emox/debug_matching_add_handle.json", {exclude_user_id: this.current_user.id, rule_key: rule.key})
    },

    matching_users_clear_handle() {
      this.$axios.$put("/api/emox/matching_users_clear_handle.json", {exclude_user_id: this.current_user.id})
    },

    session_lock_token_invalid_notify() {
      this.toast_ng("別の端末で開いたため開始できません。この端末で開始するにはリロードしてください")
    },

    start_handle() {
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
      }

      this.$axios.$put("/api/emox/session_lock_token_set_handle.json", {session_lock_token: this.current_user.session_lock_token}).then(e => {
        if (e.status === "success") {
          this.mode = "rule_select"
          this.toast_ok("ルールを選択してください")
        }
      })
    },

    rule_key_set_handle(rule) {
      this.sound_play("click")

      this.$axios.$put("/api/emox/rule_key_set_handle.json", {
        session_lock_token: this.current_user.session_lock_token,
        rule_key: rule.key,
      }).then(e => {
        if (e.status === "session_lock_token_invalid") {
          this.session_lock_token_invalid_notify()
          return
        }
        // ルール名を読み上げる場合
        if (false) {
          this.__assert__(rule.name, "rule.name")
          this.talk(rule.name)
        }
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

      this.base.matching_interval_timer_clear()

      this.__assert__(this.$ac_lobby, "ロビーの接続切れ")
      this.$ac_lobby.perform("matching_cancel")

      this.mode = "rule_select"
    },

    ////////////////////////////////////////////////////////////////////////////////

    // メニュー内の切り替え
    menu_to(v) {
      this.sound_play("click")
      this.base.menu_component = v
    },

    ////////////////////////////////////////////////////////////////////////////////

    lobby_handle() {
      if (this.mode === "lobby") {
      } else {
        this.sound_play("click")
        this.lobby_setup()
      }
    },

    lobby_unsubscribe() {
      this.ac_unsubscribe("$ac_lobby")
    },
  },

  computed: {
    base()         { return this },
    current_user() { return this.info.current_user },
    config()       { return this.info.config },

    // マッチング中のユーザー数
    matching_user_count() {
      return _.sumBy(Object.values(this.matching_user_ids_hash || {}), a => a.length) // sum { |k, v| v.size }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "application.sass"
.EmoxApp
</style>
