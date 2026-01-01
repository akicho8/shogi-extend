import { GX } from "@/components/models/gx.js"
import { illegal_lose_modal } from "./illegal_lose_modal.js"
import { illegal_takeback_modal } from "./illegal_takeback_modal.js"
import { IllegalInfo } from "shogi-player/components/models/illegal_info.js"
import { IllegalUserInfo } from "./illegal_user_info.js"
import { IllegalSelectInfo } from "./illegal_select_info.js"

export const mod_illegal = {
  mixins: [
    illegal_lose_modal,
    illegal_takeback_modal,
  ],
  data() {
    return {
      illegal_params: null, // 反則が含まれた最後の指し手(反則負けのときも反則ブロックのときも使う)
    }
  },
  methods: {
    illegal_params_reset() {
      // this.illegal_lose_modal_close()
      // this.illegal_takeback_modal_close()
      this.illegal_params_set(null)
    },

    illegal_params_set(params) {
      this.illegal_params = params
    },

    //////////////////////////////////////////////////////////////////////////////// 反則 = したら負け

    // 指したとき。反則してなくても呼ばれる。
    illegal_process(params) {
      this.illegal_takeback_modal_close()     // 反則ブロックモーダルがあれば閉じる
      this.illegal_then_resign(params)     // 自分が反則した場合は投了する
      this.illegal_lose_modal_open(params) // 反則があれば表示する
      this.ai_say_case_illegal(params)     // 反則した人を励ます
    },

    // 自分が指して反則だった場合に対局中であれば投了する
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

    //////////////////////////////////////////////////////////////////////////////// 反則 = ブロック

    // 初心者モードの反則チェックありだけど反則ブロックときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    ev_illegal_illegal_accident(illegal_hv) {
      this.illegal_takeback_modal_start(illegal_hv)
    },
    illegal_takeback_modal_start(illegal_hv) {
      // 指したときと同じ構造にしておくと、指したときと al_add の表示が同じにできる
      // → これ al_add の時点で変換すればいいだけではないか？
      // → ActionCable を経由すると last_move_info のメソッドが呼べなくなるためここで変換するしかない
      const params = {
        __standalone_mode__: true,
        ...illegal_hv.sfen_and_turn, // 反則があった局面
        illegal_hv_list: [illegal_hv],
        last_move_info_attrs: this.last_move_info_attrs_from(illegal_hv.last_move_info),
        // location_key, this.current_location.key,
      }
      this.ac_room_perform("illegal_takeback_modal_start", params) // --> app/channels/share_board/room_channel.rb
    },
    illegal_takeback_modal_start_broadcasted(params) {
      this.illegal_params_set(params)
      this.al_add(params)

      // 検討中
      if (!this.cc_play_p) {
        this.sfx_play("x")
        this.toast_danger(this.latest_illegal_name, {position: "is-bottom"})
        this.illegal_logging("検討時の反則")
        return
      }

      // 対局中
      if (this.received_from_self(params)) {
        this.cc_silent_pause_share()
      }
      this.sfx_stop_all()
      this.sfx_play("lose")                    // チーン
      this.talk(this.latest_illegal_talk_body) // 反則名をしゃべる
      this.illegal_takeback_modal_open()
      this.illegal_logging("反則ブロック発動")
    },

    // -------------------------------------------------------------------------------- 連続王手の千日手用

    // /Users/ikeda/src/shogi-player/components/mod_illegal.js と合わせること
    illegal_create_perpetual_check(e) {
      const illegal_hv = {
        illegal_info: IllegalInfo.fetch("illegal_perpetual_check"),
        sfen_and_turn: { sfen: e.sfen, turn: e.turn },
        last_move_info: e.last_move_info,
      }
      return illegal_hv
    },

    // --------------------------------------------------------------------------------

    illegal_logging(subject) {
      if (this.latest_illegal_i_am_trigger) {
        this.ac_log({subject: subject, body: [this.latest_illegal_name, this.latest_illegal_url]})
      }
    },

    // --------------------------------------------------------------------------------

    illegal_takeback_modal_submit_validate_message(illegal_select_key) {
      if (illegal_select_key === "do_resign") {
        const fn = this.illegal_user_info.resign_click_message
        if (fn) {
          return fn(this)
        }
      }
    },
  },

  computed: {
    IllegalInfo() { return IllegalInfo },
    IllegalSelectInfo() { return IllegalSelectInfo },

    IllegalUserInfo()  { return IllegalUserInfo                                           },
    illegal_user_info() { return IllegalUserInfo.fetch(this.latest_illegal_user_group_key) },

    // illegal_app_state_human() { return this.order_clock_both_ok ? "対局中" : "検討中" },

    latest_illegal_hv()                   { return this.illegal_params.illegal_hv_list[0]                                                       }, // 1つ目の反則情報
    latest_illegal_name()                 { return this.latest_illegal_hv.illegal_info.name                                                     }, // 反則名
    latest_illegal_location()             { return this.Location.fetch(this.latest_illegal_hv.last_move_info.to.attributes.location.key)        }, // 反則した▲△
    latest_illegal_it_is_my_team()        { return this.i_am_member_p && this.latest_illegal_location.key === this.my_location.key              }, // 自分は対局者かつ反則した側か？
    latest_illegal_it_is_op_team()        { return this.i_am_member_p && this.latest_illegal_location.key !== this.my_location.key              }, // 自分は対局者かつ反則してない側か？
    latest_illegal_i_am_trigger()         { return this.received_from_self(this.illegal_params)                                                 }, // 反則の発生源か？
    latest_illegal_user_name()            { return this.illegal_params.from_user_name                                                           }, // 反則者の名前

    // 反則のあった局面を再現するURL
    latest_illegal_url() {
      return this.url_for({
        ...this.current_url_params,
        xbody: null,
        body: this.illegal_params.sfen,
        turn: this.illegal_params.turn,
      })
    },

    // latest_illegal_common_message()       { return `本来であれば${this.user_call_name(this.latest_illegal_user_name)}の反則負けです`  }, // モーダルに表示する共通の文言
    // latest_illegal_resign_button_show_p() { return this.latest_illegal_it_is_my_team                                                            }, // 投了ボタン表示条件

    latest_illegal_user_group_key() {
      if (this.latest_illegal_i_am_trigger) {
        return "self"
      } else if (this.latest_illegal_it_is_my_team) {
        return "my_team"
      } else if (this.latest_illegal_it_is_op_team) {
        return "op_team"
      } else {
        return "watcher"
      }
    },

    // // エラー文言を予測する
    // illegal_takeback_modal_submit_validate_message_takeback()  { return this.illegal_takeback_modal_submit_validate_message("takeback")  },
    // illegal_takeback_modal_submit_validate_message_resign() { return this.illegal_takeback_modal_submit_validate_message("resign") },

    // しゃべる内容
    latest_illegal_talk_body() {
      return [
        this.latest_illegal_name,
        // this.latest_illegal_common_message,
        // this.latest_illegal_individual_message,
      ].join("。")
    },

  },
}
