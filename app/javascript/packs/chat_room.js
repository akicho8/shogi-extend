import _ from "lodash"
import axios from "axios"
import chess_clock from "./chess_clock"

import { PresetInfo } from "shogi-player/src/preset_info"
import { Location } from "shogi-player/src/location"
import { LastActionInfo } from "./last_action_info"

document.addEventListener("DOMContentLoaded", () => {
  App.chat_room = App.cable.subscriptions.create({
    channel: "ChatRoomChannel",
    chat_room_id: js_current_chat_room.id,
  }, {
    connected() {
      this.perform("room_in")
      this.system_say("入室しました")
    },

    disconnected() {
      // ここではすでに接続が切れている状態なので ruby 側の退出処理を呼び出すことができない。
      // しかし ruby 側の unsubscribed もまた同じタイミングで呼ばれるのでそこで退出処理を書けばよい。
    },

    received(data) {
      if (data["watch_users"]) {
        App.chat_vm.watch_users = data["watch_users"]
      }

      if (data["begin_at"]) {
        App.chat_vm.battle_setup(data)
      }

      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      if (data["turn_max"]) {
        App.chat_vm.turn_max = data["turn_max"]
        App.chat_vm.clock_counts = data["clock_counts"]
        App.chat_vm.clock_counter_reset()
      }

      if (data["kifu_body_sfen"]) {
        // これはだめ
        // if (!_.isNil(data["moved_chat_user_id"]) && data["moved_chat_user_id"] === js_global_params.current_chat_user.id) {
        //   // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
        //   // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        // } else {
        // }

        // 観戦モード(view_mode)にしたとき棋譜が最新になっているようにするため指した本人にも通知する
        App.chat_vm.kifu_body_sfen = data["kifu_body_sfen"]
      }

      if (data["lifetime_key"]) {
        App.chat_vm.current_lifetime_key = data["lifetime_key"]
      }

      if (data["human_kifu_text"]) {
        App.chat_vm.human_kifu_text = data["human_kifu_text"]
      }

      if (data["room_members"]) {
        App.chat_vm.room_members = data["room_members"]
      }

      // 発言の反映
      if (data["room_chat_message"]) {
        App.chat_vm.room_chat_messages.push(data["room_chat_message"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.chat_vm.room_name = data["room_name"]
      }

      // 終了
      if (data["end_at"]) {
        App.chat_vm.battle_end_notice(data)
      }

      // 定期的に呼ぶ場合
      if (data["action"] === "update_count") {
        console.log(data["count"])
      }
    },

    chat_say(message) {
      this.perform("chat_say", {message: message})
    },

    system_say(str) {
      this.chat_say(`<span class="has-text-info">${str}</span>`)
    },

    time_up_trigger(data) {
      this.perform("time_up_trigger", data)
    },

    give_up_trigger(data) {
      this.perform("give_up_trigger", data)
    },

    location_flip_all(data) {
      this.perform("location_flip_all", data)
    },

    play_mode_long_sfen_set(data) {
      this.perform("play_mode_long_sfen_set", data)
    },

    countdown_mode_on(location_key) {
      this.perform("countdown_mode_on", {location_key: location_key})
    },
  })

  App.chat_vm = new Vue({
    mixins: [
      chess_clock,
    ],
    el: "#chat_room_app",
    data() {
      return {
        message: "",            // 発言
        room_members:         js_current_chat_room.chat_memberships,
        room_chat_messages:   js_current_chat_room.room_chat_messages,
        kifu_body_sfen:       js_current_chat_room.kifu_body_sfen,
        current_lifetime_key: js_current_chat_room.lifetime_key,
        begin_at:             js_current_chat_room.begin_at,
        end_at:               js_current_chat_room.end_at,
        win_location_key:     js_current_chat_room.win_location_key,
        last_action_key:      js_current_chat_room.last_action_key,
        watch_users:          js_current_chat_room.watch_users,
        turn_max:             js_current_chat_room.turn_max,
        handicap:             js_current_chat_room.handicap,
        human_kifu_text:      js_current_chat_room.human_kifu_text,
      }
    },

    created() {
    },

    watch: {
      // 【使うな危険】
      // 使うとブロードキャストの無限ループを考慮する必要がでてきてカオスになる
      // ちょっとバグっただけで無限ループになる
      // 遠回りだが @input にフックしてサーバー側に送って返ってきた値で更新する
      // 遠回りだと「更新」するのが遅くなると思うかもしれないがブロードキャストする側の画面は切り替わっているので問題ない
      // ただしチャットのメッセージは除く
      // チャットの場合は入力を即座にチャット一覧に反映していないため
      // このように一概にどう扱うのがよいのか判断が難しい
      // とりあえず基本として watch は使うな
    },

    methods: {
      // バトル開始(トリガーから全体通知が来たときの処理)
      battle_setup(data) {
        console.log("DEBUG", "battle_setup")

        this.begin_at = data["begin_at"]
        this.end_at = null
        this.clock_counter_reset()
      },

      // ゲーム終了(投了により
      give_up_trigger() {
        App.chat_room.give_up_trigger({win_location_key: this.current_location.flip.key})
        App.chat_room.system_say("負けました")
      },

      // 終了の通達があった
      battle_end_notice(data) {
        if (this.current_status === "st_battling") {
          this.end_at = data["end_at"]
          this.win_location_key = data["win_location_key"]
          this.last_action_key = data["last_action_key"]

          if (this.member_p) {
            // 対局者同士
            if (this.double_team_p) {
              // 両方に所属している場合(自分対自分になっている場合)
              // 客観的な味方で報告
              this.last_action_notify_dialog_basic()
            } else {
              // 片方に所属している場合
              if (_.includes(this.my_uniq_locations, this.win_location)) {
                // 勝った方
                Vue.prototype.$dialog.alert({
                  title: "勝利",
                  message: "勝ちました",
                  type: "is-primary",
                  hasIcon: true,
                  icon: "crown",
                  iconPack: "mdi",
                })
              } else {
                // 負けた方
                Vue.prototype.$dialog.alert({
                  title: "敗北",
                  message: "負けました",
                  type: "is-primary",
                })
              }
            }
          } else {
            // 観戦者
            this.last_action_notify_dialog_basic()
          }
        }
      },

      // 客観的結果通知
      last_action_notify_dialog_basic() {
        Vue.prototype.$dialog.alert({
          type: "is-primary",
          title: "結果",
          message: `${this.last_action_info.name}により${this.turn_max}手で${this.location_name(this.win_location)}の勝ち`,
        })
      },

      // 先後反転(全体)
      location_flip_all() {
        App.chat_room.location_flip_all()
      },

      location_key_name(membership) {
        return this.location_infos[membership.location_key].name
      },

      location_mark(membership) {
        if (this.current_membership === membership) {
          return "○"
        }
      },

      // メッセージ送信
      message_enter(value) {
        if (this.message !== "") {
          App.chat_room.chat_say(this.message)
        }
        this.message = ""
      },

      // chat_user は自分か？
      user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      __membership_self_p(e) {
        return this.user_self_p(e.chat_user)
      },

      play_mode_long_sfen_set(v) {
        if (this.current_status === "st_battling") {
          App.chat_room.play_mode_long_sfen_set({kifu_body: v, clock_counter: this.clock_counter, current_location_key: this.current_location.key})
        }
      },

      location_name(location) {
        return location.any_name(this.handicap)
      },
    },
    computed: {
      // コントローラー類を非表示にする？
      any_controller_hide() {
        return this.member_p && this.current_status === "st_battling"
      },

      // チャットに表示する最新メッセージたち
      latest_room_chat_messages() {
        console.assert(js_current_chat_room.chat_window_size)
        return _.takeRight(this.room_chat_messages, js_current_chat_room.chat_window_size)
      },

      // 手番選択用
      location_infos() {
        return {
          "black": { name: "☗" + this.location_name(Location.fetch("black")), },
          "white": { name: "☖" + this.location_name(Location.fetch("white")), },
        }
      },

      chat_room() {
        return js_current_chat_room
      },

      // 現在の手番番号
      current_index() {
        return (this.handicap ? 1 : 0) + this.turn_max
      },

      // 現在手番を割り当てられたメンバー
      current_membership() {
        return this.room_members[this.current_index % this.room_members.length]
      },

      // 現在の手番はそのメンバーの先後
      current_location() {
        if (!this.current_membership) {
          return
        }
        return Location.fetch(this.current_membership.location_key)
      },

      // 現在の手番は私ですか？(1人の場合常にtrueになる)
      current_membership_is_self_p() {
        if (!this.current_membership) {
          return false
        }
        return this.__membership_self_p(this.current_membership)
      },

      // 操作する側を返す
      // 手番のメンバーが自分の場合に、自分の先後を返せばよい
      human_side_key() {
        if (this.current_status === "st_battling") {
          if (this.current_membership_is_self_p) {
            return this.current_location.key
          }
        }
        return "none"
      },

      // 盤面を反転するか？
      flip() {
        if (this.member_p) {
          if (this.double_team_p) {
            // 自分対自分の場合
            if (this.current_membership_is_self_p) {
              return this.current_location.key === "white"
            }
          } else {
            // 一方のチームに所属している場合に後手なら反転する
            return this.my_uniq_locations[0].key === "white"
          }
        } else {
          // 観戦者なので反転しない
        }
      },

      // この部屋にいる私は対局者ですか？
      member_p() {
        return this.__my_memberships.length >= 1
      },

      // 自分に対応する membership の配列
      __my_memberships() {
        return _.filter(this.room_members, e => this.user_self_p(e.chat_user))
      },

      // 自分に対応する membership の IDs
      __my_membership_ids() {
        return this.__my_memberships.map(e => e.id)
      },

      // 所属しているチーム(複数)
      my_uniq_locations() {
        return _.uniq(_.map(this.__my_memberships, e => Location.fetch(e.location_key)))
      },

      // 1人で複数のチームに所属している？ (自分対自分の場合などになる)
      double_team_p() {
        return this.my_uniq_locations.length >= 2
      },

      // 片方のチームのみに所属している？
      single_team_p() {
        return this.my_uniq_locations.length == 1
      },

      run_mode() {
        if (this.current_status === "st_before") {
          return "play_mode"
        }
        if (this.current_status === "st_battling") {
          if (this.member_p) {
            return "play_mode"
          } else {
            return "view_mode"
          }
        }
        if (this.current_status === "st_done") {
          return "view_mode"
        }
      },

      current_status() {
        if (!this.begin_at) {
          return "st_before"
        }
        if (this.end_at) {
          return "st_done"
        }
        return "st_battling"
      },

      // 手合割一覧
      preset_infos() {
        return PresetInfo.values
      },

      // 考え中？ (プレイ中？)
      thinking_p() {
        return this.current_status === "st_battling"
      },

      // 勝った方
      win_location() {
        return Location.fetch(this.win_location_key)
      },

      last_action_info() {
        return LastActionInfo.fetch(this.last_action_key)
      },
    },
  })
})
