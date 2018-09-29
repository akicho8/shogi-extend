import _ from "lodash"
import CustomPresetInfo from './custom_preset_info'
import HiraKomaInfo from './hira_koma_info'
import lobby_matching from './lobby_matching'

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/lobby_channel.rb
  App.lobby = App.cable.subscriptions.create("LobbyChannel", {
    connected() {
    },
    disconnected() {
    },

    received(data) {
      // マッチング中に変更
      if (data["matching_wait"]) {
        App.lobby_vm.matching_wait(data["matching_wait"]["matching_at"])
      }

      // ロビーでの発言追加
      if (data["lobby_message"]) {
        AppHelper.talk(data["lobby_message"].message)
        App.lobby_vm.lobby_messages.push(data["lobby_message"])
      }

      // バトル追加・更新・削除
      const battle_cud = data["battle_cud"]
      if (battle_cud) {
        const action = battle_cud.action
        const record = battle_cud.battle
        if (action === "create") {
          App.lobby_vm.battles = _.concat([record], App.lobby_vm.battles)
        }
        if (action === "update") {
          const index = App.lobby_vm.battles.findIndex(e => e.id === record.id)
          Vue.set(App.lobby_vm.battles, index, record)
        }
        if (action === "destroy") {
          App.lobby_vm.battles = App.lobby_vm.battles.filter(e => e.id !== record.id)
        }
      }

      // ユーザー追加・更新・削除
      const user_cud = data["user_cud"]
      if (user_cud) {
        const action = user_cud.action
        const record = user_cud.user
        if (action === "create") {
          App.lobby_vm.online_users = _.concat([record], App.lobby_vm.online_users)
        }
        if (action === "update") {
          const index = App.lobby_vm.online_users.findIndex(e => e.id === record.id)
          Vue.set(App.lobby_vm.online_users, index, record)
        }
        if (action === "destroy") {
          App.lobby_vm.online_users = App.lobby_vm.online_users.filter(e => e.id !== record.id)
        }
      }
    },

    chat_say(message, msg_options = {}) {
      this.perform("chat_say", {message: message, msg_options: msg_options})
    },

    setting_save(data) {
      this.perform("setting_save", data)
    },

    matching_start(data) {
      this.perform("matching_start", data)
    },

    matching_start_with_robot(data) {
      this.perform("matching_start_with_robot", data)
    },

    matching_cancel(data) {
      this.perform("matching_cancel", data)
    },

  })

  App.lobby_vm = new Vue({
    mixins: [
      lobby_matching,
    ],
    el: "#lobby_app",
    data: function() {
      return {
        // 発言
        lobby_messages: js_lobby.lobby_messages, // 発言一覧
        message: "",                                               // 発言

        // 部屋一覧
        battles: js_lobby.battles,
        columns: [
          { field: 'name', label: '部屋', },
        ],

        // ユーザー
        online_users: js_lobby.online_users,

        setting_modal_p: false,
        when_koma_one_side_force_hirate: false, // 駒落ちのとき片方を必ず平手に強制する？

        current_hira_koma_key: null,

        current_user: js_global.current_user,

        self_preset_key:      null,
        oppo_preset_key:      null,
        current_lifetime_key: null,
        current_team_key:     null,
        robot_accept_key:     null,
      }
    },

    created() {
      if (this.current_user) {
        console.assert("self_preset_key" in this.current_user.rule)
        console.assert("oppo_preset_key" in this.current_user.rule)
        console.assert("lifetime_key" in this.current_user.rule)
        console.assert("team_key" in this.current_user.rule)
        console.assert("robot_accept_key" in this.current_user.rule)

        this.self_preset_key      = this.current_user.rule.self_preset_key
        this.oppo_preset_key      = this.current_user.rule.oppo_preset_key
        this.current_lifetime_key = this.current_user.rule.lifetime_key
        this.current_team_key  = this.current_user.rule.team_key
        this.robot_accept_key     = this.current_user.rule.robot_accept_key
      }

      this.current_hira_koma_key = this.hira_koma_default_key
    },

    watch: {
      setting_modal_p(v) {
        if (!v) {
          this.setting_save()
        }
      },

      current_hira_koma_key(v) {
        if (v === "hira") {
          this.self_preset_key = "平手"
          this.oppo_preset_key = "平手"
        }
      },

      // これら入れると駒落ちではない方が必ず平手になる(が、自由度が下がるので入れない)
      self_preset_key(v) {
        if (this.when_koma_one_side_force_hirate) {
          if (v !== "平手") {
            this.oppo_preset_key = "平手"
          }
        }
      },
      oppo_preset_key(v) {
        if (this.when_koma_one_side_force_hirate) {
          if (v !== "平手") {
            this.self_preset_key = "平手"
          }
        }
      },
    },

    methods: {
      user_self_p(user) {
        if (this.current_user) {
          return user.id === this.current_user.id
        }
      },

      battle_setting_open_click() {
        if (AppHelper.login_required()) {
          return
        }
        this.setting_modal_p = true
      },

      battle_setting_close_click() {
        this.setting_modal_p = false
      },

      setting_save() {
        App.lobby.setting_save({
          self_preset_key:  this.current_self_preset_info.key,
          oppo_preset_key:  this.current_oppo_preset_info.key,
          lifetime_key:     this.current_lifetime_key,
          team_key:      this.current_team_key,
          robot_accept_key: this.robot_accept_key,
        })
      },

      message_enter(value) {
        if (AppHelper.login_required()) {
          return
        }
        if (this.message !== "") {
          App.lobby.chat_say(this.message)
        }
        this.message = ""
        this.$refs.message_input.focus()
      },

      memberships_format(battle) {
        if (true) {
          return battle.memberships.map(e => {
            return `<img class="avatar_image" src="${e.user.avatar_url}" />${e.user.name}`
          }).join(" ")
        } else {
          const list = _.groupBy(battle.memberships, "location_key")
          return _.map(list, (list, key) => {
            return list.map(e => {
              return `<img class="avatar_image" src="${e.user.avatar_url}" />${e.user.name}`
            }).join("・")
          }).join(" vs ")
        }
      },
    },

    computed: {
      // チャットに表示する最新メッセージたち
      latest_lobby_messages() {
        return _.takeRight(this.lobby_messages, 10)
      },

      // 選択中の持ち時間項目
      current_lifetime_info() {
        return LifetimeInfo.fetch(this.current_lifetime_key)
      },

      current_team_info() {
        return TeamInfo.fetch(this.current_team_key)
      },

      current_robot_accept_info() {
        return RobotAcceptInfo.fetch(this.robot_accept_key)
      },

      // 現在選択されている手合割情報
      current_self_preset_info() { return CustomPresetInfo.fetch(this.self_preset_key) },
      current_oppo_preset_info() { return CustomPresetInfo.fetch(this.oppo_preset_key) },

      hira_koma_default_key() {
        if (this.self_preset_key === "平手" && this.oppo_preset_key === "平手") {
          return "hira"
        } else {
          return "koma"
        }
      },

      current_hira_koma_info() {
        return HiraKomaInfo.fetch(this.current_hira_koma_key)
      },
    },
  })
})
