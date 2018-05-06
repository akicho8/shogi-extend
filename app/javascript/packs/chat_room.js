import _ from "lodash"
import axios from "axios"
import chat_room_name from "./chat_room_name.js"
import chess_clock from "./chess_clock.js"

import { PresetInfo } from 'shogi-player/src/preset_info.js'
import { Location } from 'shogi-player/src/location.js'

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

// app/assets/javascripts/cable/subscriptions/chat.coffee
// App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" }
//
// # app/assets/javascripts/cable/subscriptions/lobby.coffee
// App.cable.subscriptions.create { channel: "LobbyChannel" }

document.addEventListener('DOMContentLoaded', () => {
  App.chat_room = App.cable.subscriptions.create({
    channel: "ChatRoomChannel",
    chat_room_id: chat_room_app_params.chat_room.id,
  }, {
    connected() {
      console.log("ChatRoomChannel.connected")
      this.perform("room_in")
      this.system_say("入室しました")
    },

    disconnected() {
      console.log("ChatRoomChannel.disconnected")
      // 【注意】接続が切れている状態なのでここから perform で ruby 側を呼び出すことはできない。が、ruby 側の unsubscribed は自動的に呼ばれるのでそこで退室時の処理を書ける
      // this.perform("room_out")
      // this.system_say("退室しました")
    },

    received(data) {
      // 部屋名の共有
      if (data["chat_room"]) {
        // alert(data["chat_room"])
      }

      // 結局使ってない
      if (!_.isNil(data["without_id"]) && data["without_id"] === js_global_params.current_chat_user.id) {
        console.log("skip")
        return
      }

      if (data["kansen_users"]) {
        App.chat_vm.kansen_users = data["kansen_users"]
      }

      // ↓この方法にすればシンプル
      // if (data["chat_room"]) {
      //   const v = data["chat_room"]
      //   // App.chat_vm.kifu_body_sfen = v.chat_room.kifu_body_sfen
      //   App.chat_vm.preset_key = v.preset_key
      //   App.chat_vm.battle_begin_at = v.battle_begin_at
      // }

      if (data["battle_begin_at"]) {
        App.chat_vm.game_setup(data)
      }

      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      if (data["turn_max"]) {
        App.chat_vm.turn_max = data["turn_max"]
        App.chat_vm.clock_counts = data["clock_counts"]
        App.chat_vm.think_counter_reset()
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

      if (data["preset_key"]) {
        App.chat_vm.preset_key = data["preset_key"]
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
      if (data["chat_article"]) {
        App.chat_vm.chat_articles.push(data["chat_article"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.chat_vm.room_name = data["room_name"]
      }

      // 終了
      if (data["battle_end_at"]) {
        App.chat_vm.game_ended(data)
      }
    },

    chat_say(chat_message_body) {
      this.perform("chat_say", {chat_message_body: chat_message_body})
    },

    system_say(str) {
      this.chat_say(`<span class="has-text-info">${str}</span>`)
    },

    room_name_changed(room_name) {
      this.perform("room_name_changed", {room_name: room_name})
    },

    kifu_body_sfen_broadcast(data) {
      this.perform("kifu_body_sfen_broadcast", data)
    },

    // preset_key_update(data) {
    //   this.perform("preset_key_update", data)
    // },

    lifetime_key_update(data) {
      this.perform("lifetime_key_update", data)
    },

    game_start(data) {
      this.perform("game_start", data)
    },

    timeout_game_end(data) {
      this.perform("timeout_game_end", data)
    },

    give_up_game_end(data) {
      this.perform("give_up_game_end", data)
    },

    location_flip_all(data) {
      this.perform("location_flip_all", data)
    },

    kansen_users_update_by_polling(data) {
      this.perform("kansen_users_update_by_polling", data)
    },
  })

  App.chat_vm = new Vue({
    mixins: [
      chat_room_name,
      chess_clock,
    ],
    el: "#chat_room_app",
    data() {
      return {
        message: "",                          // 発言
        chat_articles: [],                    // 発言一覧
        human_kifu_text: "(human_kifu_text)", // 棋譜

        // turn_max: 0,

        // 入室したときに局面を反映する(これはビューの方で行なってもよい)
        // App.chat_vm.kifu_body_sfen = chat_room_app_params.chat_room.kifu_body_sfen
        room_members: chat_room_app_params.room_members,
        kifu_body_sfen: chat_room_app_params.chat_room.kifu_body_sfen,
        preset_key: chat_room_app_params.chat_room.preset_key,
        current_lifetime_key: chat_room_app_params.chat_room.lifetime_key,
        battle_begin_at: chat_room_app_params.chat_room.battle_begin_at,
        battle_end_at: chat_room_app_params.chat_room.battle_end_at,
        win_location_key: chat_room_app_params.chat_room.win_location_key,
        give_up_location_key: chat_room_app_params.chat_room.give_up_location_key,
        kansen_users: chat_room_app_params.chat_room.kansen_users,
        turn_max: chat_room_app_params.chat_room.turn_max,
      }
    },

    watch: {
      // 使ってはいけない
      // 使うとブロードキャストの無限ループを考慮する必要がでてきてカオスになる
      // ちょっとバグっただけで無限ループになる
      // 遠回りだが @input にフックしてサーバー側に送って返ってきた値で更新する
      // 遠回りだと「更新」するのが遅くなると思うかもしれないがブロードキャストする側の画面は切り替わっているので問題ない
      // ただしチャットのメッセージは除く。チャットの場合は入力を即座にチャット一覧に反映していないため
      // このように一概にどう扱うのがよいのか判断が難しい
      // 間違っても watch は使うな
    },

    created() {
      // setInterval(() => {
      //   App.chat_room.kansen_users_update_by_polling()
      // }, 1000 * 5)
    },

    methods: {
      room_in() {
      },

      // バトル開始！(1人がトリガー)
      game_start() {
        App.chat_room.system_say("バトル開始！")
        App.chat_room.game_start()
      },

      // バトル開始(トリガーから全体通知が来たときの処理)
      game_setup(data) {
        this.battle_begin_at = data["battle_begin_at"]
        this.battle_end_at = null
        this.think_counter_reset()
      },

      // 投了
      give_up_game_end() {
        App.chat_room.give_up_game_end({win_location_key: this.current_location.flip.key, give_up_location_key: this.current_location.key})
        App.chat_room.system_say("負けました")
      },

      // 時間切れ(生き残っている全員で送信)
      timeout_game_end() {
        if (this.current_membership) {
          App.chat_room.timeout_game_end({win_location_key: this.current_location.flip.key})
        }
      },

      // 終了
      game_ended(data) {
        this.battle_end_at = data["battle_end_at"]
        this.win_location_key = data["win_location_key"]
        this.give_up_location_key = data["give_up_location_key"]
        App.chat_room.system_say(`${this.current_location.flip.name}の勝ち！`)

        if (this.my_location_key) {
          // 対局者同士
          if (this.win_location_key === this.my_location_key) {
            // 勝った方
            Vue.prototype.$dialog.alert({
              title: "勝利",
              message: "勝ちました",
              type: 'is-primary',
              hasIcon: true,
              icon: 'crown',
              iconPack: 'mdi',
            })
          } else {
            // 負けた方
            Vue.prototype.$dialog.alert({
              title: "敗北",
              message: "負けました",
              type: 'is-primary',
            })
          }
        } else {
          // 観戦者
          Vue.prototype.$dialog.alert({title: "結果", message: `${this.current_location.flip.name}の勝ち！`, type: 'is-primary'})
        }
      },

      // // 手合割の変更
      // preset_key_update(v) {
      //   if (this.preset_key !== v) {
      //     this.preset_key = v
      //     App.chat_room.preset_key_update({preset_key: this.current_preset_info.name})
      //     App.chat_room.system_say(`手合割を${this.current_preset_info.name}に変更しました`)
      //   }
      // },

      // 持ち時間の変更
      lifetime_key_update(v) {
        if (this.current_lifetime_key !== v) {
          this.current_lifetime_key = v
          App.chat_room.lifetime_key_update({lifetime_key: this.current_lifetime_info.key})
          App.chat_room.system_say(`持ち時間を${this.current_lifetime_info.name}に変更しました`)
        }
      },

      // 先後反転(全体)
      location_flip_all() {
        App.chat_room.location_flip_all()
      },

      location_key_name(v) {
        return this.location_infos[v].name
      },

      // メッセージ送信
      message_enter(value) {
        if (this.message !== "") {
          App.chat_room.chat_say(this.message)
        }
        this.message = ""
      },

      // chat_user は自分か？
      chat_user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },

      // FIXME: ActionCable の方で行う
      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)
        params.append("think_counter", this.think_counter) // 使用秒数も記録する

        // TODO: axios を使わない
        axios({
          method: "post",
          timeout: 1000 * 10,
          headers: {"X-TAISEN": true},
          url: chat_room_app_params.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger"})
            App.chat_room.chat_say(`<span class="has-text-danger">${response.data.error_message}</span>`)
          }
          if (response.data.kifu_body_sfen) {
            if (false) {
              // これまでの方法
              this.kifu_body_sfen = response.data.kifu_body_sfen
            } else {
              // 局面を共有する
              // /Users/ikeda/src/shogi_web/app/channels/chat_room_channel.rb の receive を呼び出してブロードキャストする

              // App.chat_room.send({...chat_room_app_params, kifu_body_sfen: response.data.sfen})

              App.chat_room.kifu_body_sfen_broadcast(response.data)
              App.chat_room.system_say(response.data.last_hand)
            }
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },

    },
    computed: {
      // チャットに表示する最新メッセージたち
      latest_chat_articles() {
        return _.takeRight(this.chat_articles, 10)
      },

      // 手番選択用
      location_infos() {
        return {
          "black": { name: "☗" + (this.komaochi_p ? "下手" : "先手"), },
          "white": { name: "☖" + (this.komaochi_p ? "上手" : "後手"), },
        }
      },

      // 現在の手番
      current_location() {
        const index = (this.komaochi_p ? 1 : 0) + this.turn_max
        return Location.values[index % Location.values.length]
      },

      // 駒落ち？
      komaochi_p() {
        return this.current_preset_info.first_location_key === "white"
      },

      // 自分の中間情報
      current_membership() {
        return _.find(this.room_members, (e) => this.chat_user_self_p(e.chat_user))
      },

      // 自分の手番
      my_location_key() {
        if (this.current_membership) {
          return this.current_membership.location_key
        }
      },

      // 今は自分の手番か？
      my_teban_p() {
        return this.my_location_key === this.current_location.key
      },

      // 盤面を反転するか？
      flip() {
        return this.my_location_key === "white"
      },

      run_mode() {
        if (this.my_location_key) {
          return "play_mode"
        } else {
          return "view_mode"
        }
      },

      // 手合割一覧
      preset_infos() {
        return PresetInfo.values
      },

      // 現在選択されている手合割情報
      current_preset_info() {
        return PresetInfo.fetch(this.preset_key)
      },

      // 考え中？ (プレイ中？)
      thinking_p() {
        return !_.isNil(this.battle_begin_at) && _.isNil(this.battle_end_at)
      },
    },
  })
})
