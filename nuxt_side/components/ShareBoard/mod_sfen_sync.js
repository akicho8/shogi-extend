import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { SfenSyncParamsWrapper } from "./models/sfen_sync_params_wrapper.js"

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

      this.resend_init()

      // 反則情報リストを作る /Users/ikeda/src/shogi-player/components/mod_illegal.js
      const illegal_hv_list = [...e.illegal_hv_list]
      const illegal_hv = this.perpetual_check_detect(e)
      if (illegal_hv) {
        illegal_hv_list.push(illegal_hv)
      }

      // last_move_info の内容を簡潔したものを共有する (そのまま共有すればよくないか？)
      this.sfen_sync_params = {
        __standalone_mode__: true,
        sfen: e.sfen,
        turn: e.turn,
        illegal_hv_list: illegal_hv_list,
        clock_box_params: this.ac_room_perform_params_wrap(this.clock_box_share_params_factory("cc_behavior_silent")), // 指し手と合わせて時計の情報も送る
        last_move_info_attrs: this.last_move_info_attrs_from(e.last_move_info),
        // location_key, this.current_location.key,
      }

      if (e.snapshot_hash) {
        this.sfen_sync_params["snapshot_hash"] = e.snapshot_hash
      }
      if (e.op_king_check) {
        this.sfen_sync_params["op_king_check"] = e.op_king_check
      }
      if (e.checkmate_stat) {
        this.sfen_sync_params["checkmate_stat"] = e.checkmate_stat
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

    last_move_info_attrs_from(last_move_info) {
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
      GX.assert_present(this.sfen_sync_params, "this.sfen_sync_params")
      const params = {
        ...this.sfen_sync_params,
        resend_failed_count: this.resend_failed_count, // 1以上:再送回数
      }
      if (this.resend_failed_count >= 1) {
        params.label = `再送${this.resend_failed_count}`
        params.label_type = "is-warning"
      }
      this.ac_room_perform("sfen_sync", params) // --> app/channels/share_board/room_channel.rb
      this.resend_start()  // もちろん ac_room が有効でないときは呼ばない
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
        this.resend_receive_success_send(params)            // 受信OKを指し手に通知する
        this.think_mark_all_clear()                         // マークを消す

        // 指したので時間切れ発動予約をキャンセルする
        // alice が残り1秒で指すが、bob 側の時計は0秒になっていた場合にこれが必要になる
        // これがないと alice は時間切れになっていないと言うが、bob側は3秒後に発動してしまって時間切れだと言って食い違いが発生する
        // この猶予を利用してわざと alice が残り0秒指しするのが心配かもしれないが、
        // 時計が0になった時点で即座にBCするので問題ない
        this.cc_timeout_judge_delay_stop()

        if (this.next_is_self_p(params)) {
          // 自分vs自分なら視点変更
          if (this.self_vs_self_p) {
            const location = this.current_sfen_info.location_by_offset(params.last_move_info_attrs.next_turn_offset)
            // if (this.debug_mode_p) {
            // } else {
            this.viewpoint = location.key
            // }
          }
        }

        this.illegal_process(params)               // 反則関連

        this.checkmate_then_resign(params)              //  詰みなら次の手番の人は投了する

        this.sfen_synced_after_notice(params)           // 反則がないときだけ指し手と次の人を通知する
      }

      this.ai_say_case_turn(params)
      this.action_log_add_and_branch_setup(params)
    },

    async sfen_synced_after_notice(params) {
      this.next_turn_message = null
      if (this.can_next_step_p(params)) {                                    // 反則がなかった場合
        if (!this.cc_play_p) {
          if (params.op_king_check) {
            await this.toast_primary("王手")
          }
        }
        if (this.yomiagable_p) {
          await this.sb_talk(this.user_call_name(params.from_user_name)) // 「aliceさん」
          await this.sb_talk(params.last_move_info_attrs.yomiage)      // 「7 6 ふ」
        }
        this.next_turn_call(params)                                      // 「次は〜」
      }
    },

    next_turn_call(params) {
      if (params.next_user_name) {                       // 順番設定しているときだけ入っている
        if (this.tn_bell_call_p) {
          if (this.next_is_self_p(params)) {
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

    // 勝利
    // 詰みであればこれから指す人に投了させる
    checkmate_then_resign(params) {
      if (this.debug_mode_p && !this.__SYSTEM_TEST_RUNNING__) {
        if (params.checkmate_stat) {
          const fixed_ms = params.checkmate_stat.elapsed_ms.toFixed(2)
          this.toast_primary(`${params.checkmate_stat.yes_or_no} (${fixed_ms} ms)`, {position: "is-top-left", talk: false})
        }
      }
      if (this.illegal_none_p(params)) {
        if (this.knock_out_p(params)) {
          if (!this.cc_play_p) {
            this.toast_danger("詰み")
          }
          if (this.next_is_self_p(params)) {
            this.resign_call({checkmate: true})
          }
        }
      }
    },

    // 履歴追加からの(必要なら)ブランチ作成とすればいいのだけど、
    // ブランチを作成する必要があるならそれは「変化」なので履歴追加の時点でラベルに「変化」を入れる
    action_log_add_and_branch_setup(params) {
      params = {...params}

      if (this.honpu_branch_need_p) {
        if (GX.blank_p(params.label)) {
          params.label = "変化"
          params.label_type = "is-primary"
        }
      }

      this.al_add(params)
      this.honpu_branch_setup(params) // ブランチが空の場合はブランチを作る
    },

    illegal_none_p(params)    { return GX.blank_p(params.illegal_hv_list)                           },
    illegal_exist_p(params)   { return GX.present_p(params.illegal_hv_list)                         },

    knock_out_p(params)       { return params.checkmate_stat && params.checkmate_stat.yes_or_no === "yes" },

    can_next_step_p(params)       { return this.illegal_none_p(params) && !this.knock_out_p(params) },
    next_is_self_p(params)    { return this.user_name === params.next_user_name                     },
  },
  computed: {
    // どの状態のときに読み上げるか？
    yomiagable_p() {
      return this.order_enable_p && this.cc_play_p && this.yomiage_mode_info.key === "is_yomiage_mode_on"
    },
  },
}
