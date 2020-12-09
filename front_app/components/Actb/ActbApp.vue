<template lang="pug">
.ActbApp(:class="mode")
  ActbEmotionApp( :base="base" v-if="mode === 'emotion'")
  ActbLobby(      :base="base" v-if="mode === 'lobby'")
  ActbRuleSelect( :base="base" v-if="mode === 'rule_select'")
  ActbMatching(   :base="base" v-if="mode === 'matching'")
  ActbBattleApp(  :base="base" v-if="mode === 'battle'")
  ActbResultApp(  :base="base" v-if="mode === 'result'")
  ActbRanking(    :base="base" v-if="mode === 'ranking'")
  ActbHistoryApp( :base="base" v-if="mode === 'history'")
  ActbBuilderApp( :base="base" v-if="mode === 'builder'" ref="builder")
  ActbMenuApp(    :base="base" v-if="mode === 'menu'")
  ActbChessClock( :base="base" v-if="mode === 'chess_clock'")

  details(v-if="base.debug_read_p")
    summary DEBUG
    DebugPrint(:grep="/./")
</template>

<script>
import { support } from "./support.js"

// Mixins
import { application_room          } from "./application_room.js"
import { application_emotion       } from "./application_emotion.js"
import { application_lobby_message } from "./application_lobby_message.js"
import { application_battle        } from "./application_battle.js"
import { application_matching      } from "./application_matching.js"
import { application_history       } from "./application_history.js"
import { application_history_vote  } from "./application_history_vote.js"
import { application_notification  } from "./application_notification.js"
import { application_new_challenge } from "./application_new_challenge.js"
import { application_question_show } from "./application_question_show.js"
import { application_user_show     } from "./application_user_show.js"
import { config                    } from "./config.js"
import { RuleInfo                  } from "./models/rule_info.js"
import { OxMarkInfo                } from "./models/ox_mark_info.js"
import { SkillInfo                 } from "./models/skill_info.js"
import { EmotionInfo               } from "./models/emotion_info.js"
import { EmotionFolderInfo         } from "./models/emotion_folder_info.js"

export default {
  name: "ActbApp",
  mixins: [
    support,
    config,

    application_question_show,
    application_user_show,

    application_room,
    application_emotion,
    application_lobby_message,
    application_battle,
    application_matching,
    application_history_vote,
    application_notification,
    application_new_challenge,

    application_history,
  ],
  props: {
    info: { required: true },
  },

  data() {
    return {
      current_user: this.info.current_user,

      mode: null,
      sub_mode: null,

      school_user_ids:        null, // オンラインのユーザーIDs
      room_user_ids:          null, // 対戦中のユーザーIDs
      matching_user_ids_hash: null, // 対戦待ちユーザーIDsのハッシュでルール名がキー

      // 問題編集
      edit_question_id: null, // IDを入れて builder_handle を叩けば、そのIDの編集画面に飛ぶ

      // リソース
      RuleInfo:   null,
      OxMarkInfo: null,
      SkillInfo:  null,
      EmotionInfo: null,
      EmotionFolderInfo: null,

      // メニュー用
      menu_component: null,

      // 引数に画面遷移の指定があるとき何度も遷移してしまうのを伏せぐため
      redirect_counter: 0,

      // デバッグ
      debug_summary_p: false, // ちょっとした表示
      debug_force_edit_p: false, // 他人の問題を編集できる
      debug_read_p:    false, // 表示系(安全)
      debug_write_p:   false, // 更新系(危険)

      // リアクティブではないもの
      // $ac_school: null, // --> base/channels/actb/school_channel.rb
      // $ac_lobby:  null, // --> base/channels/actb/lobby_channel.rb
      // $ac_room:   null, // --> base/channels/actb/room_channel.rb
      // $ac_battle: null, // --> base/channels/actb/battle_channel.rb
    }
  },

  async created() {
    if (this.development_p) {
      this.debug_summary_p    = true
      this.debug_force_edit_p = true
      this.debug_read_p       = true
      this.debug_write_p      = true
    }

    await this.api_get("resource_fetch", {}, e => {
      this.RuleInfo          = RuleInfo.memory_record_reset(e.RuleInfo)
      this.OxMarkInfo        = OxMarkInfo.memory_record_reset(e.OxMarkInfo)
      this.SkillInfo         = SkillInfo.memory_record_reset(e.SkillInfo)
      this.EmotionInfo       = EmotionInfo.memory_record_reset(e.EmotionInfo)
      this.EmotionFolderInfo = EmotionFolderInfo.memory_record_reset(e.EmotionFolderInfo)
      this.app_setup()
    })
  },

  beforeDestroy() {
    this.lobby_unsubscribe()
    this.school_unsubscribe()
    this.room_unsubscribe()
    this.battle_unsubscribe()
  },

  mounted() {
    this.ga_click(`トレーニングバトル`)
  },

  methods: {
    app_setup() {
      this.school_setup()

      if (this.info.warp_to) {
        if (this.info.warp_to === "emotion_index" || this.info.warp_to === "emotion_edit") {
          this.emotion_setup()
        }
        if (
          this.info.warp_to === "battle_sy_versus" ||
          this.info.warp_to === "battle_sy_marathon" ||
          this.info.warp_to === "battle_sy_singleton" ||
          this.info.warp_to === "battle_sy_hybrid") {
          this.room_setup(this.info.room)
        }
        if (this.info.warp_to === "result") {
          this.room_setup(this.info.room)
        }
        if (this.info.warp_to === "builder" || this.info.warp_to === "builder_haiti" || this.info.warp_to === "builder_form") {
          this.builder_handle()
        }
        if (this.info.warp_to === "ranking") {
          this.ranking_handle()
        }
        if (this.info.warp_to === "history") {
          this.history_handle()
        }
        if (this.info.warp_to === "chess_clock") {
          this.chess_clock_handle()
        }
        if (this.info.warp_to === "ov_question_info") {
          this.ov_question_info_set(this.info.question_id)
        }
        if (this.info.warp_to === "ov_user_info") {
          this.ov_user_info_set(this.info.current_user.id)
        }
        if (this.info.warp_to === "login_lobby") {
          this.lobby_setup()
        }
      } else {
        this.lobby_setup()
      }
    },

    reload_if_outdated() {
      return this.silent_api_get("revision_fetch", {}, e => {
        if (this.base.config.revision === e.revision) {
          this.debug_alert(`revision: ${this.base.config.revision} OK`)
        } else {
          this.ok_notice("新しいプログラムがあるので更新します", {onend: () => location.reload(true)})
        }
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    school_setup() {
      this.__assert__(this.$ac_school == null, "this.$ac_school == null")
      this.$ac_school = this.ac_subscription_create({channel: "Actb::SchoolChannel"})
    },
    school_unsubscribe() {
      this.ac_unsubscribe("$ac_school")
    },

    active_users_status_broadcasted(params) {
      if (params.actb_school_user_ids) {
        this.school_user_ids = params.actb_school_user_ids
      }
      if (params.actb_room_user_ids) {
        this.room_user_ids = params.actb_room_user_ids
      }
    },

    emotion_setup() {
      this.lobby_unsubscribe()
      this.mode = "emotion"
    },

    // 練習モードを止める
    rensyu_yameru_handle() {
      this.__assert__(this.room.bot_user_id != null, "this.room.bot_user_id != null")
      this.lobby_setup_without_cable()
      this.sound_play("click")
    },

    lobby_setup_without_cable() {
      this.battle_unsubscribe()
      this.room_unsubscribe()

      this.mode = "lobby"
      this.room = null          // 対戦中ではないことを判定するため消しておく
      this.reload_if_outdated()
    },

    lobby_setup() {
      this.lobby_setup_without_cable()

      this.lobby_messages_setup()
      this.notification_setup()

      this.debug_alert("lobby_setup")
      this.__assert__(this.$ac_lobby == null, "ロビーが解放されてないのに再び接続しようとしている")
      this.$ac_lobby = this.ac_subscription_create({channel: "Actb::LobbyChannel"})

      this.ov_redirect_onece()
    },

    ov_redirect_onece() {
      if (this.redirect_counter >= 1) {
        return
      }

      let id = null

      id = this.$route.query.question_id
      if (id) {
        this.ov_question_info_set(id)
      }

      this.redirect_counter += 1
    },

    lobby_messages_setup() {
      this.lobby_messages = []
      this.lobby_message_body = ""
      this.api_get("lobby_messages_fetch", {}, e => {
        this.lobby_messages = e.lobby_messages
      })
    },

    debug_matching_add_handle(rule) {
      this.api_put("debug_matching_add_handle", {exclude_user_id: this.current_user.id, rule_key: rule.key}, e => {})
    },

    matching_users_clear_handle() {
      this.api_put("matching_users_clear_handle", {exclude_user_id: this.current_user.id}, e => {})
    },

    session_lock_token_invalid_notify() {
      this.warning_notice("別の端末で開いたため開始できません。この端末で開始するにはリロードしてください")
    },

    async start_handle(practice_p) {
      if (this.sns_login_required()) { return }
      if (this.handle_name_required()) { return }

      this.sound_play("click")
      await this.reload_if_outdated()
      this.new_challenge_snackbar_clear() // 挑戦者登場の snackbar を消去

      this.practice_p = practice_p

      this.api_put("session_lock_token_set_handle", {session_lock_token: this.current_user.session_lock_token}, e => {
        if (e.status === "success") {
          this.mode = "rule_select"
          this.say("ルールを選択してください")
        }
      })
    },

    handle_name_required() {
      if (this.config.user_name_required) {
        if (this.current_user) {
          if (!this.current_user.name_input_at) {
            this.warning_notice("名前を入力してください")
            this.$router.push({name: "settings-profile"})
            return true
          }
        }
      }
    },

    rule_key_set_handle(rule) {
      this.sound_play("click")

      this.api_put("rule_key_set_handle", {
        session_lock_token: this.current_user.session_lock_token,
        rule_key: rule.key,
      }, e => {
        if (e.status === "session_lock_token_invalid") {
          this.session_lock_token_invalid_notify()
          return
        }
        // ルール名を読み上げる場合
        if (false) {
          this.__assert__(rule.name, "rule.name")
          this.say(rule.name)
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

    emotion_index_handle() {
      if (this.mode === "emotion") {
      } else {
        this.sound_play("click")
        this.emotion_setup()
      }
    },

    lobby_unsubscribe() {
      this.ac_unsubscribe("$ac_lobby")
    },

    // 問題一覧「+」
    async builder_handle() {
      if (this.mode === "builder") {
      } else {
        await this.reload_if_outdated()
        if (this.sns_login_required()) { return }
        if (this.handle_name_required()) { return }
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
        if (this.sns_login_required()) { return }
        this.mode = "history"
      }
    },

    menu_handle() {
      if (this.mode === "menu") {
        if (this.menu_component === "ActbMenuRoot") {
        } else {
          this.menu_to("ActbMenuRoot")
        }
      } else {
        this.lobby_unsubscribe()
        this.mode = "menu"
      }
    },

    chess_clock_handle() {
      if (this.mode === "chess_clock") {
      } else {
        this.lobby_unsubscribe()
        this.mode = "chess_clock"
      }
    },
  },

  computed: {
    base() { return this },

    // current_user() {
    //   return this.info.current_user
    // },

    // いったんスクリプトに飛ばしているのは sessions[:return_to] を設定するため
    // login_path() {
    //   const url = new URL(location)
    //   url.searchParams.set("goto_login", true)
    //   return url.toString()
    // },

    user_type() {
      if (this.current_user) {
        if (this.current_user.key === "sysop") {
          return "admin"
        } else {
          return "general"
        }
      }
    },

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
.ActbApp
</style>
