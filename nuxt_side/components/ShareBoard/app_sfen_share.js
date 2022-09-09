import _ from "lodash"
import { BehaviorEffectInfo } from "./models/behavior_effect_info.js"

export const app_sfen_share = {
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
      this.__assert__(this.current_sfen, "this.current_sfen")
      if (this.development_p) {
        this.__assert__(e.sfen === this.current_sfen, "e.sfen === this.current_sfen")
        this.__assert__(lmi.next_turn_offset === this.current_sfen_turn_offset_max, "lmi.next_turn_offset === this.current_sfen_turn_offset_max")
      }

      this.x_retry_count = 0    // 着手したので再送回数を0にしておく

      // last_move_info の内容を簡潔したものを共有する (そのまま共有すればよくないか？)
      this.sfen_share_params = {
        lmi: {
          kif_without_from:    lmi.to_kif_without_from,        // "☗7六歩"
          next_turn_offset:    lmi.next_turn_offset,           // 1
          player_location_key: lmi.player_location.key,        // "black"
          yomiage:             lmi.to_yomiage,                 // "ななろくふ"
          effect_key:          lmi.effect_key,                 // 効果音キー
          foul_names:          lmi.foul_list.map(e => e.name), // ["駒ワープ", "王手放置"]
        },
        sfen: this.current_sfen, // e.sfen でもよい
        turn: lmi.next_turn_offset,
        clock_box_params: this.clock_box_share_params_factory(), // 指し手と合わせて時計の情報も送る
      }

      // シャウトモード用
      const ks = lmi.killed_soldier
      if (ks) {
        this.sfen_share_params.lmi.killed_soldier = {
          location_key: ks.location.key,
          piece_key:    ks.piece.key,
          promoted:     ks.promoted,
        }
      }

      const next_user_name = this.user_name_by_turn(lmi.next_turn_offset) // alice, bob がいて初手を指したら bob
      if (next_user_name) {
        this.sfen_share_params["next_user_name"] = next_user_name
      }

      if (this.clock_box && this.clock_box.play_p) {
        this.sfen_share_params["elapsed_sec"] = this.clock_box.opponent.elapsed_sec_old // タップし終わったあとなので相手の情報を取る
      }

      this.sequence_code_embed()

      this.fast_sound_effect_func(this.sfen_share_params) // ブロードキャスト前に実行
    },

    // 指し手の配信
    sfen_share() {
      if (this.ac_room) { // ac_room が有効でないときに sfen_share_callback_set を呼ばないようにするため
        this.send_success_p = false // 数ms後に相手から応答があると true になる
        const params = {
          x_retry_count: this.x_retry_count, // 0:初回 1以上:再送回数
          ...this.sfen_share_params,
        }
        this.ac_room_perform("sfen_share", params) // --> app/channels/share_board/room_channel.rb
        this.sfen_share_callback_set()
      } else {
        // 自分しかいないため即履歴とする
        // これによって履歴を使うためにわざわざ部屋を立てる必要がなくなる
        const params = {
          ...this.ac_room_perform_default_params(), // これがなくても動くがアバターが守護獣になってしまう。from_avatar_path 等を埋め込むことでプロフィール画像が出る
          ...this.sfen_share_params,
        }
        this.foul_show(params)
        this.al_add(params)
      }
    },

    // 指し手を受信
    sfen_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
      } else {
        // もし edit_mode に入っている場合は強制的に解除する
        if (this.edit_mode_p) {
          this.tl_alert("指し手のBCにより編集を解除")
          this.sp_run_mode = "play_mode"
        }

        // 即座にシャウトする
        this.fast_sound_effect_func(params)

        // 受信したSFENを盤に反映
        this.receive_xsfen(params)
      }

      // 時計も更新する
      this.clock_box_share_broadcasted(params.clock_box_params)

      if (true) {
        // 指したので時間切れ発動予約をキャンセルする
        // alice が残り1秒で指すが、bob 側の時計は0秒になっていた場合にこれが必要になる
        // これがないと alice は時間切れになっていないと言うが、bob側は3秒後に発動してしまって時間切れだと言って食い違いが発生する
        // この猶予を利用してわざと alice が残り0秒指しするのが心配かもしれないが、
        // 時計が0になった時点で即座にBCするので問題ない
        this.cc_auto_time_limit_delay_stop()

        if (this.user_name === params.next_user_name) {
          if (this.next_notify_p) {
            this.tn_notify()
          }

          // 自分vs自分なら視点変更
          if (this.self_vs_self_p) {
            const location = this.current_sfen_info.location_by_offset(params.lmi.next_turn_offset)
            this.sp_viewpoint = location.key
          }
        }

        this.from_user_name_valid(params) // 指し手制限をしていないとき別の人が指したかチェックする

        // 反則があれば表示
        this.foul_show(params)

        // 「alice ▲76歩」と表示しながら
        this.toast_ok(`${params.from_user_name} ${params.lmi.kif_without_from}`, {toast_only: true})

        this.next_turn_message = null
        if (this.yomiagable_p) {
          // 「aliceさん」の発声後に「7 6 ふー！」を発声する
          this.talk(this.user_call_name(params.from_user_name), {
            onend: () => this.talk(params.lmi.yomiage, {
              onend: () => {
                if (params.next_user_name) {
                  if (this.next_notify_p) {
                    this.next_turn_message = `次は、${this.user_call_name(params.next_user_name)}の手番です`
                    this.toast_ok(this.next_turn_message)
                  }
                }
              },
            }),
          })
        }

        this.received_ok_send(params)
      }

      this.al_add(params)
    },
    from_user_name_valid(params) {
      if (this.development_p) {
        const name = this.user_name_by_turn(params.lmi.next_turn_offset - 1) // alice, bob がいて初手を指したら alice
        if (name) {
          if (params.from_user_name !== name) {
            this.tl_alert(`${this.user_call_name(name)}の手番でしたが${this.user_call_name(params.from_user_name)}が指しました`)
          }
        }
      }
    },

    // 即時実行させたいエフェクト
    // エフェクトのタイミングがずれないようにローカルでは自分側だけで実行する
    // ブロードキャストは相手側だけで実行する
    fast_sound_effect_func(params) {
      this.vibrate_short()

      if (this.is_shout_mode_on) {
        const info = BehaviorEffectInfo.fetch(params.lmi.effect_key)
        this.sound_play_random(info.sound_key)

        this.delay_block(0.25, () => {
          // location_key: ks.location.key,
          // piece_key:    ks.piece.key,
          // promoted:     ks.promoted,
          if (params.lmi.killed_soldier) {
            const info = BehaviorEffectInfo.fetch("killed_and_death")
            this.sound_play_random(info.sound_key)
          }
        })
      }
    },
  },
  computed: {
    // 時計が設置されてなくて読み上げOFFのときはダメ
    // 時計が設置されている または 読み上げON はOK
    yomiagable_p() {
      // 本番で自分vs自分は読み上げない
      if (!this.development_p && this.self_vs_self_p) {
        return false
      }

      return this.clock_box || this.yomiage_mode_info.key === "is_yomiage_mode_on"
    },
  },
}
