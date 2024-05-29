import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_sfen_share = {
  data() {
    return {
      sfen_share_params: null, // リトライするとき用に送るパラメータを保持しておく
      next_turn_message: null, // 直近の「次は○○の手番です」のメッセージを保持する(テスト用)
    }
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // あとで再送するかもしれないのでいったん送るパラメータを作って保持しておく
    sfen_share_params_set(e) {
      const lmi = e.last_move_info

      this.tl_add("SP", lmi.to_kif_without_from, lmi)
      Gs.assert(this.current_sfen, "this.current_sfen")
      if (this.development_p) {
        Gs.assert(e.sfen === this.current_sfen, "e.sfen === this.current_sfen")
        Gs.assert(lmi.next_turn_offset === this.current_sfen_turn_max, "lmi.next_turn_offset === this.current_sfen_turn_max")
      }

      this.rs_failed_count = 0    // 着手したので再送回数を0にしておく

      const illegal_names = lmi.illegal_list.map(e => e.name)  // ["駒ワープ", "王手放置"]

      if (this.illegal_behavior_info.perpetual_check_p) {
        this.perpetual_cop.increment(e.snapshot_hash) // 同一局面になった回数をカウント
        // 反則名を配列を作る
        // sp から ["駒ワープ", "王手放置"] などがくるのでそれに「千日手」を追加する
        if (this.perpetual_cop.available_p(e.snapshot_hash)) {    // 千日手か？
          illegal_names.push("千日手")                            // ["駒ワープ", "王手放置", "千日手"]
        }
      }

      // last_move_info の内容を簡潔したものを共有する (そのまま共有すればよくないか？)
      this.sfen_share_params = {
        sfen: e.sfen,
        turn: e.turn,
        lmi: {
          kif_without_from:    lmi.to_kif_without_from,                   // "☗7六歩"
          next_turn_offset:    lmi.next_turn_offset,                      // 1
          player_location_key: lmi.player_location.key,                   // "black"
          yomiage:             lmi.to_yomiage,                            // "ななろくふ"
          effect_key:          lmi.effect_key,                            // 効果音キー
        },
        illegal_names: illegal_names, // ["駒ワープ", "王手放置", "千日手"]
        clock_box_params: this.ac_room_perform_params_wrap(this.clock_box_share_params_factory("cc_behavior_silent")), // 指し手と合わせて時計の情報も送る
      }

      const next_user_name = this.turn_to_user_name(lmi.next_turn_offset) // alice, bob がいて初手を指したら bob
      if (next_user_name) {
        this.sfen_share_params["next_user_name"] = next_user_name
      }

      if (this.clock_box && this.clock_box.play_p) {
        this.sfen_share_params["elapsed_sec"] = this.clock_box.opponent.elapsed_sec_old // タップし終わったあとなので相手の情報を取る
      }

      this.sequence_code_embed()
    },

    // 指し手の配信
    sfen_share() {
      if (this.ac_room) { // ac_room が有効でないときに rs_sfen_share_after_hook を呼ばないようにするため
        this.rs_send_success_p = false // 数ms後に相手から応答があると true になる
        const params = {
          ...this.sfen_share_params,
          rs_failed_count: this.rs_failed_count, // 1以上:再送回数
        }
        if (this.rs_failed_count >= 1) {
          params.label = `再送${this.rs_failed_count}`
          params.label_type = "is-warning"
        }
        this.ac_room_perform("sfen_share", params) // --> app/channels/share_board/room_channel.rb
        this.rs_sfen_share_after_hook()
      } else {
        // 自分しかいないため即履歴とする
        // これによって履歴を使うためにわざわざ部屋を立てる必要がなくなる
        const params = {
          ...this.ac_room_perform_default_params(), // これがなくても動くがアバターが守護獣になってしまう。from_avatar_path 等を埋め込むことでプロフィール画像が出る
          ...this.sfen_share_params,
        }
        this.illegal_modal_handle(params.illegal_names)
        this.al_add(params)
      }
    },

    // 指し手を受信
    sfen_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
      } else {
        // もし edit に入っている場合は強制的に解除する
        if (this.edit_mode_p) {
          this.tl_alert("指し手のBCにより編集を解除")
          this.sp_mode = "play"
        }

        // 受信したSFENを盤に反映
        this.sfen_share_data_receive(params)
        this.se_piece_move() // 次のフレームで指した音を出す(すぐに鳴らすと音がフライングしてしまう)
      }

      // 時計も更新する
      if (this.received_from_self(params)) {
        // 自分の時計は変更しない
      } else {
        // 他者の時計の内部情報を更新する
        Gs.assert(params.clock_box_params.cc_behavior_key == "cc_behavior_silent", 'params.clock_box_params.cc_behavior_key == "cc_behavior_silent"')
        if (true) {
          this.clock_box_share_broadcasted(params.clock_box_params)
        } else {
          this.clock_share_data_receive(params.clock_box_params) // 他者の時計の内部情報だけを更新する
        }
      }

      if (true) {
        // 指したので時間切れ発動予約をキャンセルする
        // alice が残り1秒で指すが、bob 側の時計は0秒になっていた場合にこれが必要になる
        // これがないと alice は時間切れになっていないと言うが、bob側は3秒後に発動してしまって時間切れだと言って食い違いが発生する
        // この猶予を利用してわざと alice が残り0秒指しするのが心配かもしれないが、
        // 時計が0になった時点で即座にBCするので問題ない
        this.cc_timeout_judge_delay_stop()

        if (this.user_name === params.next_user_name) {
          // 自分vs自分なら視点変更
          if (this.self_vs_self_p) {
            const location = this.current_sfen_info.location_by_offset(params.lmi.next_turn_offset)
            this.viewpoint = location.key
          }
        }

        this.from_user_name_valid(params)               // 指し手制限をしていないとき別の人が指したかチェックする

        this.illegal_then_give_up(params)               // 自分が反則した場合は投了する
        this.illegal_modal_handle(params.illegal_names) // 反則があれば表示する
        this.illegal_logging(params)                    // 反則の状態を記録する
        this.ai_say_case_illegal(params)                // 反則した人を励ます

        this.from_user_toast(params)                    // 誰が操作したかを表示する
        this.sfen_shared_after_notice(params)           // 反則がないときだけ指し手と次の人を通知する
        this.rs_receive_success_send(params)            // 受信OKを指し手に通知する
      }

      this.ai_say_case_turn(params)
      this.al_add(params)
    },
    from_user_name_valid(params) {
      if (this.development_p) {
        const name = this.turn_to_user_name(params.lmi.next_turn_offset - 1) // alice, bob がいて初手を指したら alice
        if (name) {
          if (params.from_user_name !== name) {
            this.tl_alert(`${this.user_call_name(name)}の手番でしたが${this.user_call_name(params.from_user_name)}が指しました`)
          }
        }
      }
    },
    from_user_toast(params) {
      const options = {
        talk: false,
        // position: "is-top",
      }
      // if (this.order_enable_p) {
      // ・「alice ▲76歩」は常に表示する (反則のときも)
      // ・検討中にサイレント更新されると困る
      // , position: "is-top", type: "is-dark"
      // this.toast_ok(`${params.from_user_name} ${params.lmi.kif_without_from}`, options)
      // }
    },

    sfen_shared_after_notice(params) {
      this.next_turn_message = null
      if (Gs.blank_p(params.illegal_names)) {                // 反則がなかった場合
        if (this.yomiagable_p) {
          this.sb_talk(this.user_call_name(params.from_user_name), { // 「aliceさん」
            onend: () => this.sb_talk(params.lmi.yomiage, {          // 「7 6 ふー！」
              onend: () => this.next_turn_call(params),            // 「次は〜」
            }),
          })
        } else {
          this.next_turn_call(params) // 「次は〜」
        }
      }
    },

    next_turn_call(params) {
      if (params.next_user_name) {                       // 順番設定しているときだけ入っている
        if (this.next_notify_p) {
          if (this.user_name === params.next_user_name) {
            this.tn_notify()
          }
          this.next_turn_message = `${this.next_turn_message_prefix(params)}${this.user_call_name(params.next_user_name)}の手番です`
          this.toast_ok(this.next_turn_message)
        }
      }
    },

    next_turn_message_prefix(params) {
      Gs.assert(this.order_unit, "this.order_unit")

      // console.log(this.change_per)                                             // => 2
      // console.log(params.lmi.next_turn_offset)                             // => 1
      // console.log(params.from_user_name)                                   // => alice
      // console.log(params.next_user_name)                                   // => bob
      // console.log(this.turn_to_user_name(params.lmi.next_turn_offset - 2)) // => dave
      // console.log(this.turn_to_user_name(params.lmi.next_turn_offset - 1)) // => alice
      // console.log(this.turn_to_user_name(params.lmi.next_turn_offset - 0)) // => bob
      // console.log(this.order_unit.order_state.state_name)                  // => O2State
      // console.log(this.order_unit.order_state.teams[0].length)             // => 2
      // console.log(this.order_unit.order_state.teams[1].length)             // => 2

      if (this.order_unit.order_state.state_name === "O2State") {           // 正確なチーム分けモードなら
        const turn = params.lmi.next_turn_offset
        const location = this.turn_to_location(turn)                        // 渡ってきたこれから指す側のチームを求めて
        if (this.order_unit.order_state.teams[location.code].length >= 2) { // そのチーム内にメンバーが2人以上いる場合は
          const user_name = this.turn_to_user_name(turn - 2)                // 2手前の名前を求めて
          if (params.next_user_name === user_name) {                        // 再度同じ人が指す場合には
            return "次も、"
          }
        }
      } else {
        // O1State の場合は所属チームが曖昧になるため判定ができない
      }

      return "次は、"
    },

    // 即時実行させたいエフェクト
    // エフェクトのタイミングがずれないようにローカルでは自分側だけで実行する
    // ブロードキャストは相手側だけで実行する
    fast_sound_effect_func(params) {
      this.beat_call("short")
    },

    // 自分が反則した場合に自動投了が有効なら投了する
    illegal_then_give_up(params) {
      if (this.received_from_self(params)) {
        if (Gs.present_p(params.illegal_names)) {
          this.auto_resign_then_give_up()
        }
      }
    },

    // 反則の状態を記録する
    illegal_logging(params) {
      if (this.received_from_self(params)) {
        if (Gs.present_p(params.illegal_names)) {
          if (this.cc_play_p) {
            const body = [
              params.from_user_name,
              params.illegal_names,
              this.current_url,
            ]
            this.ac_log({subject: "反則発動", body: Gs.short_inspect(body)})
          }
        }
      }
    },
  },
  computed: {
    yomiagable_p() {
      // 時計が設置されてなくて読み上げOFFのときはダメ
      // 時計が設置されている または 読み上げON はOK

      // // 本番で自分vs自分は読み上げない
      // if (this.self_vs_self_p) {
      //   return false
      // }

      // // 順番設定 OFF なら読み上げない
      // if (!this.order_enable_p) {
      //   return false
      // }
      //
      // return this.clock_box || this.yomiage_mode_info.key === "is_yomiage_mode_on"
      //
      // 時計ONなら
      // return this.cc_play_p

      return this.yomiage_mode_info.key === "is_yomiage_mode_on"
    },
  },
}
