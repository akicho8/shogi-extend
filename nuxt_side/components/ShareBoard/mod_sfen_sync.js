import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { SfenSyncParamsWrapper } from "@/components/models/sfen_sync_params_wrapper.js"

const SELF_VS_SELF_MODE = false

export const mod_sfen_sync = {
  data() {
    return {
      sfen_sync_params: null, // リトライするとき用に送るパラメータを保持しておく
      next_turn_message: null, // 直近の「次は○○の手番です」のメッセージを保持する(テスト用)
    }
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // あとで再送するかもしれないのでいったん送るパラメータを作って保持しておく
    sfen_sync_params_set(e) {
      this.tl_add("SP", e.last_move_info.to_kif_without_from, e.last_move_info)
      GX.assert(this.current_sfen, "this.current_sfen")
      if (this.development_p) {
        GX.assert(e.sfen === this.current_sfen, "e.sfen === this.current_sfen")
        GX.assert(e.last_move_info.next_turn_offset === this.current_sfen_turn_max, "e.last_move_info.next_turn_offset === this.current_sfen_turn_max")
      }

      this.rs_failed_count = 0    // 着手したので再送回数を0にしておく

      // 反則名リストを作る /Users/ikeda/src/shogi-player/components/mod_illegal.js
      const illegal_hv_list = [...e.illegal_hv_list]

      // 千日手
      if (true) {
        this.perpetual_cop.increment(e.snapshot_hash) // 同一局面になった回数をカウント
        // sp から ["駒ワープ", "王手放置"] などがくるのでそれに「千日手」を追加する
        if (this.perpetual_cop.available_p(e.snapshot_hash)) {    // 千日手か？
          const illegal_hv = this.illegal_create_perpetual_check(e)
          if (this.foul_mode_info.perpetual_check_p) {
            illegal_hv_list.push(illegal_hv)
          } else {
            this.illegal_activation(illegal_hv)
          }
        }
      }

      // last_move_info の内容を簡潔したものを共有する (そのまま共有すればよくないか？)
      this.sfen_sync_params = {
        sfen: e.sfen,
        turn: e.turn,
        checkmate_stat: e.checkmate_stat,
        illegal_hv_list: illegal_hv_list,
        clock_box_params: this.ac_room_perform_params_wrap(this.clock_box_share_params_factory("cc_behavior_silent")), // 指し手と合わせて時計の情報も送る
        simple_hand_attributes: this.simple_hand_attributes_from(e.last_move_info),
      }

      // if (this.development_p) {
      //   JSON.stringify(this.sfen_sync_params)
      // }

      const next_user_name = this.turn_to_user_name(e.last_move_info.next_turn_offset) // alice, bob がいて初手を指したら bob
      if (next_user_name) {
        this.sfen_sync_params["next_user_name"] = next_user_name
      } else {
        if (SELF_VS_SELF_MODE) {
          // 次に指す人がいない場合に前の人を入れておけば一応自分vs自分ができる
          const next_user_name = this.turn_to_user_name(e.last_move_info.next_turn_offset - 1)
          this.toast_primary(`次に指す人がいないため変わりに${this.user_call_name(next_user_name)}が指そう`)
          this.sfen_sync_params["next_user_name"] = next_user_name
        }
      }

      if (this.clock_box && this.clock_box.play_p) {
        this.sfen_sync_params["elapsed_sec"] = this.clock_box.opponent.elapsed_sec_old // タップし終わったあとなので相手の情報を取る
      }

      this.sequence_code_embed()
    },

    simple_hand_attributes_from(last_move_info) {
      return {
        kif_without_from:    last_move_info.to_kif_without_from, // "☗7六歩"
        next_turn_offset:    last_move_info.next_turn_offset,    // 1
        player_location_key: last_move_info.player_location.key, // "black"
        yomiage:             last_move_info.to_yomiage,          // "ななろくふ"
        effect_key:          last_move_info.effect_key,          // 効果音キー
      }
    },

    // 指し手の配信
    sfen_sync() {
      if (this.ac_room == null) {
        // 自分しかいないため即履歴とする
        // これによって履歴を使うためにわざわざ部屋を立てる必要がなくなる
        const params = {
          ...this.ac_room_perform_default_params(), // これがなくても動くがアバターがアバターになってしまう。from_avatar_path 等を埋め込むことでプロフィール画像が出る
          ...this.sfen_sync_params,
        }
        this.illegal_modal_open_handle(params.illegal_hv_list)
        this.think_mark_all_clear()                         // マークを消す
        this.al_add(params)
        this.honpu_branch_setup(params)
        return
      }

      this.rs_send_success_p = false // 数ms後に相手から応答があると true になる
      const params = {
        ...this.sfen_sync_params,
        rs_failed_count: this.rs_failed_count, // 1以上:再送回数
      }
      if (this.rs_failed_count >= 1) {
        params.label = `再送${this.rs_failed_count}`
        params.label_type = "is-warning"
      }
      this.ac_room_perform("sfen_sync", params) // --> app/channels/share_board/room_channel.rb
      this.rs_sfen_sync_after_hook()  // もちろん ac_room が有効でないときは呼ばない
    },

    // 指し手を受信
    sfen_sync_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
      } else {
        // もし edit に入っている場合は強制的に解除する
        if (this.edit_mode_p) {
          this.tl_alert("指し手のBCにより編集を解除")
          this.sp_mode = "play"
        }

        // 受信したSFENを盤に反映
        this.sfen_sync_dto_receive(params)
        this.se_piece_move() // 次のフレームで指した音を出す(すぐに鳴らすと音がフライングしてしまう)
      }

      // 時計も更新する
      if (this.received_from_self(params)) {
        // 自分の時計は変更しない
      } else {
        // 他者の時計の内部情報を更新する
        GX.assert(params.clock_box_params.cc_behavior_key === "cc_behavior_silent", 'params.clock_box_params.cc_behavior_key === "cc_behavior_silent"')
        if (true) {
          this.clock_box_share_broadcasted(params.clock_box_params)
        } else {
          this.clock_share_dto_receive(params.clock_box_params) // 他者の時計の内部情報だけを更新する
        }
      }

      if (true) {
        // 指したので時間切れ発動予約をキャンセルする
        // alice が残り1秒で指すが、bob 側の時計は0秒になっていた場合にこれが必要になる
        // これがないと alice は時間切れになっていないと言うが、bob側は3秒後に発動してしまって時間切れだと言って食い違いが発生する
        // この猶予を利用してわざと alice が残り0秒指しするのが心配かもしれないが、
        // 時計が0になった時点で即座にBCするので問題ない
        this.cc_timeout_judge_delay_stop()

        if (this.next_is_self(params)) {
          // 自分vs自分なら視点変更
          if (this.self_vs_self_p) {
            const location = this.current_sfen_info.location_by_offset(params.simple_hand_attributes.next_turn_offset)
            this.viewpoint = location.key
          }
        }

        this.illegal_then_resign(params)               // 自分が反則した場合は投了する
        this.illegal_modal_open_handle(params.illegal_hv_list) // 反則があれば表示する
        this.ai_say_case_illegal(params)                // 反則した人を励ます

        this.checkmate_then_resign(params)              //  詰みなら次の手番の人は投了する

        this.sfen_syncd_after_notice(params)           // 反則がないときだけ指し手と次の人を通知する
        this.rs_receive_success_send(params)            // 受信OKを指し手に通知する
        this.think_mark_all_clear()                         // マークを消す
      }

      this.ai_say_case_turn(params)
      this.al_add(params)
      this.honpu_branch_setup(params)
    },

    async sfen_syncd_after_notice(params) {
      this.next_turn_message = null
      if (this.next_step_p(params)) {                                    // 反則がなかった場合
        if (this.yomiagable_p) {
          await this.sb_talk(this.user_call_name(params.from_user_name)) // 「aliceさん」
          await this.sb_talk(params.simple_hand_attributes.yomiage)      // 「7 6 ふ」
        }
        this.next_turn_call(params)                                      // 「次は〜」
      }
    },

    next_turn_call(params) {
      if (params.next_user_name) {                       // 順番設定しているときだけ入っている
        if (this.tn_bell_call_p) {
          if (this.next_is_self(params)) {
            this.tn_bell_call()
          }
        }
        if (this.tn_name_call_p) {
          this.next_turn_message = this.tn_message_build(params)
          this.toast_primary(this.next_turn_message)
        }
      }
    },

    // 即時実行させたいエフェクト
    // エフェクトのタイミングがずれないようにローカルでは自分側だけで実行する
    // ブロードキャストは相手側だけで実行する
    fast_sound_effect_func(params) {
      this.beat_call("short")
    },

    // 自分が反則した場合に自動投了が有効なら投了する
    illegal_then_resign(params) {
      if (this.received_from_self(params)) {
        if (this.illegal_exist_p(params)) {
          if (this.cc_play_p) {
            this.ac_log({subject: "反則負け", body: {"種類": params.illegal_hv_list.map(e => e.illegal_info.name), "局面": this.current_url}})
          }
          this.resign_call()
        }
      }
    },

    // 勝利
    // 詰みであればこれから指す人に投了させる
    checkmate_then_resign(params) {
      if (this.debug_mode_p && !this.__SYSTEM_TEST_RUNNING__) {
        const fixed_ms = params.checkmate_stat.elapsed_ms.toFixed(2)
        this.toast_danger(`${params.checkmate_stat.yes_or_no} (${fixed_ms} ms)`, {position: "is-top-left"})
      }
      if (this.illegal_none_p(params)) {
        if (this.checkmate_exist_p(params)) {
          if (this.next_is_self(params)) {
            this.resign_call()
          }
        }
      }
    },

    illegal_none_p(params)    { return GX.blank_p(params.illegal_hv_list)                           },
    illegal_exist_p(params)   { return GX.present_p(params.illegal_hv_list)                         },
    checkmate_none_p(params)  { return params.checkmate_stat.yes_or_no !== "yes"                    },
    checkmate_exist_p(params) { return params.checkmate_stat.yes_or_no === "yes"                    },
    next_step_p(params)       { return this.illegal_none_p(params) && this.checkmate_none_p(params) },
    next_is_self(params)      { return this.user_name === params.next_user_name                     },
  },
  computed: {
    // どの状態のときに読み上げるか？
    yomiagable_p() {
      return this.order_enable_p && this.cc_play_p && this.yomiage_mode_info.key === "is_yomiage_mode_on"
    },
  },
}
