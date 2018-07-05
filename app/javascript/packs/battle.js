import _ from "lodash"
import assert from "assert"
import axios from "axios"
import chess_clock from "./chess_clock"

import { PresetInfo } from "shogi-player/src/preset_info"
import { Location } from "shogi-player/src/location"
import { LastActionInfo } from "./last_action_info"

document.addEventListener("DOMContentLoaded", () => {
  App.battle = App.cable.subscriptions.create({
    channel: "BattleChannel",
    battle_id: js_battle.id,
  }, {
    connected() {
      this.perform("room_in")
    },

    disconnected() {
      // ここではすでに接続が切れている状態なので ruby 側の退出処理を呼び出すことができない。
      // しかし ruby 側の unsubscribed もまた同じタイミングで呼ばれるのでそこで退出処理を書けばよい。
    },

    received(data) {
      if (data["watch_users"]) {
        App.battle_vm.watch_users = data["watch_users"]
      }

      if (data["begin_at"]) {
        App.battle_vm.battle_setup(data)
      }

      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      if (data["turn_max"]) {
        App.battle_vm.turn_max = data["turn_max"]
        App.battle_vm.clock_counts = data["clock_counts"]
        App.battle_vm.clock_counter_reset()
        // App.battle_vm.next_run_if_robot() // ここでCPUに指してもらう手もある。これはブロードキャストされているのでここで呼んではいけない。
      }

      if (data["full_sfen"]) {
        // これはだめ
        // if (!_.isNil(data["moved_user_id"]) && data["moved_user_id"] === js_global_params.current_user.id) {
        //   // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
        //   // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        // } else {
        // }

        // 観戦モード(view_mode)にしたとき棋譜が最新になっているようにするため指した本人にも通知する
        App.battle_vm.full_sfen = data["full_sfen"]
      }

      // if (data["lifetime_key"]) {
      //   App.battle_vm.current_lifetime_key = data["lifetime_key"]
      // }

      if (data["human_kifu_text"]) {
        App.battle_vm.human_kifu_text = data["human_kifu_text"]
      }

      if (data["memberships"]) {
        App.battle_vm.memberships = data["memberships"]
      }

      // 発言の反映
      if (data["chat_message"]) {
        App.battle_vm.chat_messages.push(data["chat_message"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.battle_vm.room_name = data["room_name"]
      }

      // 終了
      if (data["end_at"]) {
        App.battle_vm.battle_end_notice(data)
      }

      // 定期的に呼ぶ場合
      if (data["action"] === "update_count") {
        console.log(data["count"])
      }
    },

    chat_say(message, msg_options = {}) {
      this.perform("chat_say", {message: message, msg_options: msg_options})
    },

    time_up(data) {
      this.perform("time_up", data)
    },

    give_up(data) {
      this.perform("give_up", data)
    },

    hebokisin(data) {
      this.perform("hebokisin", data)
    },

    play_mode_long_sfen_set(data) {
      this.perform("play_mode_long_sfen_set", data)
    },

    countdown_flag_on(location_key) {
      this.perform("countdown_flag_on", {location_key: location_key})
    },

    next_run_if_robot() {
      this.perform("next_run_if_robot")
    },
  })

  App.battle_vm = new Vue({
    mixins: [
      chess_clock,
    ],
    el: "#battle_app",
    data() {
      assert(js_battle.memberships)
      assert(js_battle.chat_messages)

      return {
        message: "",            // 発言
        memberships:          js_battle.memberships,
        chat_messages:        js_battle.chat_messages,
        full_sfen:            js_battle.full_sfen,
        current_lifetime_key: js_battle.lifetime_key,
        current_platoon_key:  js_battle.platoon_key,
        begin_at:             js_battle.begin_at,
        end_at:               js_battle.end_at,
        win_location_key:     js_battle.win_location_key,
        last_action_key:      js_battle.last_action_key,
        watch_users:          js_battle.watch_users,
        turn_max:             js_battle.turn_max,
        handicap:             js_battle.handicap,
        human_kifu_text:      js_battle.human_kifu_text,
      }
    },

    created() {
      setTimeout(() => this.next_run_if_robot(), 1000)
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
        this.begin_at = data["begin_at"]
        this.end_at = null
        this.clock_counter_reset()
      },

      give_up() {
        Vue.prototype.$dialog.confirm({
          title: "確認",
          message: "本当に投了しますか？",
          confirmText: "はい",
          cancelText: "いいえ",
          onConfirm: () => {
            App.battle.give_up({win_location_key: this.current_location.flip.key})
            App.battle.chat_say("負けました")
          },
        })
      },

      hebokisin() {
        App.battle.hebokisin()
      },

      next_run_if_robot() {
        if (this.host_player_p) {
          App.battle.next_run_if_robot()
        }
      },

      // 終了の通達があった
      battle_end_notice(data) {
        if (this.xstate_key === "st_battle_now") {
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
                if (this.last_action_key === "TORYO") {
                  // 自ら投了した場合、負けは自明なので何も出さない
                } else {
                  Vue.prototype.$dialog.alert({
                    title: "敗北",
                    message: "負けました",
                    type: "is-primary",
                  })
                }
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
          App.battle.chat_say(this.message)
        }
        this.message = ""
      },

      // user は自分か？
      user_self_p(user) {
        return user.id === js_global_params.current_user.id
      },

      __membership_self_p(e) {
        return this.user_self_p(e.user)
      },

      play_mode_long_sfen_set(v) {
        if (this.xstate_key === "st_battle_now") {
          App.battle.play_mode_long_sfen_set({kifu_body: v, clock_counter: this.clock_counter, current_location_key: this.current_location.key, current_index: this.current_index})
        }
      },

      location_name(location) {
        return location.any_name(this.handicap)
      },
    },
    computed: {
      // コントローラー類を非表示にする？
      any_controller_hide() {
        return this.member_p && this.xstate_key === "st_battle_now"
      },

      // チャットに表示する最新メッセージたち
      latest_chat_messages() {
        console.assert(js_battle.chat_window_size)
        return _.takeRight(this.chat_messages, js_battle.chat_window_size)
      },

      // 手番選択用
      location_infos() {
        return {
          "black": { name: "☗" + this.location_name(Location.fetch("black")), },
          "white": { name: "☖" + this.location_name(Location.fetch("white")), },
        }
      },

      battle() {
        return js_battle
      },

      // 現在の手番番号
      current_index() {
        return (this.handicap ? 1 : 0) + this.turn_max
      },

      // 現在手番を割り当てられたメンバー
      current_membership() {
        assert(this.memberships)
        return this.memberships[this.current_index % this.memberships.length]
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
        if (this.xstate_key === "st_battle_now") {
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
        return _.filter(this.memberships, e => this.user_self_p(e.user))
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

      // 対局者のなかから最初に登場する人間の情報
      __primary_member() {
        return this.memberships.find(e => e.user.race_key === "human")
      },

      // 自分はホストなのか？
      host_player_p() {
        return _.includes(this.__my_memberships, this.__primary_member)
      },

      run_mode() {
        if (this.xstate_key === "st_before") {
          return "play_mode"
        }
        if (this.xstate_key === "st_battle_now") {
          if (this.member_p) {
            return "play_mode"
          } else {
            return "view_mode"
          }
        }
        if (this.xstate_key === "st_done") {
          return "view_mode"
        }
      },

      xstate_key() {
        if (!this.begin_at) {
          return "st_before"
        }
        if (this.end_at) {
          return "st_done"
        }
        return "st_battle_now"
      },

      battle_now_p() {
        return this.xstate_key === "st_battle_now"
      },

      button_active_p() {
        return this.battle_now_p && this.current_membership_is_self_p
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
