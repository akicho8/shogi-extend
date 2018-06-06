import _ from "lodash"
import { CustomPresetInfo } from './custom_preset_info'
import { HiraKomaInfo } from './hira_koma_info'

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/lobby_channel.rb
  App.lobby = App.cable.subscriptions.create("LobbyChannel", {
    connected() {
    },
    disconnected() {
    },

    received(data) {
      if (data["chat_room_created"]) {
        App.lobby_vm.chat_rooms = _.concat([data["chat_room_created"]], App.lobby_vm.chat_rooms)
      }
      if (data["chat_rooms"]) {
        App.lobby_vm.chat_rooms = data["chat_rooms"]
      }
      if (data["online_users"]) {
        // App.lobby_vm.online_users = data["online_users"] // FIXME: indexにアクセスした直後に必ず呼ばれる
      }
      if (data["matching_wait"]) {
        App.lobby_vm.matching_wait(data["matching_wait"])
      }
      if (data["lobby_chat_message"]) {
        App.lobby_vm.lobby_chat_messages.push(data["lobby_chat_message"])
      }
    },

    chat_say(message) {
      this.perform("chat_say", {message: message})
    },

    setting_save(data) {
      this.perform("setting_save", data)
    },

    matching_start(data) {
      this.perform("matching_start", data)
    },

    matching_cancel(data) {
      this.perform("matching_cancel", data)
    },
  })

  App.lobby_vm = new Vue({
    el: "#lobby_app",
    data: function() {
      return {
        // 発言
        lobby_chat_messages: lobby_app_params.lobby_chat_messages, // 発言一覧
        message: "",                                               // 発言

        // 部屋一覧
        chat_rooms: lobby_app_params.chat_rooms,
        columns: [
          { field: 'name', label: '部屋', },
        ],

        // ユーザー
        online_users: lobby_app_params.online_users,

        matching_at: js_global_params.current_chat_user.matching_at, // マッチングをサーバー側で受理した日時

        setting_modal_p: false,

        current_hira_koma_key: null,
        ps_preset_key: js_global_params.current_chat_user["ps_preset_key"],
        po_preset_key: js_global_params.current_chat_user["po_preset_key"],
        current_lifetime_key: js_global_params.current_chat_user["lifetime_key"],

        when_koma_one_side_force_hirate: false, // 駒落ちのとき片方を必ず平手に強制する？
      }
    },

    created() {
      this.current_hira_koma_key = this.hira_koma_default_key
    },

    watch: {
      current_hira_koma_key(v) {
        if (v === "hira") {
          this.ps_preset_key = "平手"
          this.po_preset_key = "平手"
        }
      },

      // これら入れると駒落ちではない方が必ず平手になる(が、自由度が下がるので入れない)
      ps_preset_key(v) {
        if (this.when_koma_one_side_force_hirate) {
          if (v !== "平手") {
            this.po_preset_key = "平手"
          }
        }
      },
      po_preset_key(v) {
        if (this.when_koma_one_side_force_hirate) {
          if (v !== "平手") {
            this.ps_preset_key = "平手"
          }
        }
      }
    },

    methods: {
      user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      matching_setting_open_click() {
        this.setting_modal_p = true
      },

      matching_setting_close_click() {
        this.setting_modal_p = false
      },

      setting_save() {
        App.lobby.setting_save({
          ps_preset_key: this.current_ps_preset_info.key,
          po_preset_key: this.current_po_preset_info.key,
          lifetime_key: this.current_lifetime_key,
        })
      },

      matching_start() {
        App.lobby.matching_start({})
      },

      matching_cancel() {
        this.matching_at = null
        App.lobby.matching_cancel()
      },

      matching_wait(data) {
        this.matching_at = data["matching_at"]
      },

      message_enter(value) {
        if (this.message !== "") {
          App.lobby.chat_say(this.message)
        }
        this.message = ""
      },

      room_members_format(chat_room) {
        const list = _.groupBy(chat_room.chat_memberships, "location_key")
        return _.map(list, (list, key) => {
          return list.map(e => {
            return `<img class="avatar_image" src="${e.chat_user.avatar_url}" />${e.chat_user.name}`
          }).join("・")
        }).join(" vs ")
      },
    },

    computed: {
      // チャットに表示する最新メッセージたち
      latest_lobby_chat_messages() {
        return _.takeRight(this.lobby_chat_messages, 10)
      },

      // 選択中の持ち時間項目
      current_lifetime_info() {
        return LifetimeInfo.fetch(this.current_lifetime_key)
      },

      // 現在選択されている手合割情報
      current_ps_preset_info() { return CustomPresetInfo.fetch(this.ps_preset_key) },
      current_po_preset_info() { return CustomPresetInfo.fetch(this.po_preset_key) },

      hira_koma_default_key() {
        if (this.ps_preset_key === "平手" && this.po_preset_key === "平手") {
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
