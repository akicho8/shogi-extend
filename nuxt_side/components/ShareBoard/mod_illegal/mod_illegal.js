import { GX } from "@/components/models/gx.js"
import { illegal_modal } from "./illegal_modal.js"
import { IllegalInfo } from "shogi-player/components/models/illegal_info.js"

export const mod_illegal = {
  mixins: [illegal_modal],
  data() {
    return {
      latest_illegal_hv: null, // 最後の反則名(system test 用)
    }
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 反則 = ブロック

    // 初心者モードの反則チェックありだけど反則ブロックときに反則したときの処理
    // ここは何もしなければ将棋ウォーズのようになる
    ev_illegal_illegal_accident(illegal_hv) {
      this.illegal_activation(illegal_hv)
    },
    illegal_activation(illegal_hv) {
      // 指したときと同じ構造にしておくと、指したときと al_add の表示が同じにできる。ActionCable に行く前なのでメソッドが呼べる。
      const params = {
        ...this.ac_room_perform_default_params(),
        ...illegal_hv.sfen_and_turn, // 反則があった局面
        illegal_hv_list: [illegal_hv],
        simple_hand_attributes: this.simple_hand_attributes_from(illegal_hv.last_move_info),
      }
      this.illegal_show(params)         // 当事者には最速で知らせたいのでブロードキャスト前にする
      this.illegal_share(params)        // 共有する
      this.ac_log({subject: "反則ブロック", body: {"状況": this.illegal_app_state_human, "種類": illegal_hv.illegal_info.name, "局面": this.current_url}})
    },
    illegal_share(params) {
      if (this.ac_room == null) {
        this.illegal_share_broadcasted(params)
        return
      }
      this.ac_room_perform("illegal_share", params) // --> app/channels/share_board/room_channel.rb
    },
    illegal_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
        this.illegal_show(params)
      }
      this.al_add(params)
    },
    async illegal_show(params) {
      const illegal_hv = params.illegal_hv_list[0]
      this.latest_illegal_hv = illegal_hv
      this.sfx_play("x")
      await this.sb_toast_danger(illegal_hv.illegal_info.name, {position: "is-bottom"})
      if (this.order_clock_both_ok) {
        this.sb_toast_danger(`将棋のルールであればこの時点で${this.user_call_name(params.from_user_name)}の負けです`, {position: "is-bottom"})
      }
    },

    // -------------------------------------------------------------------------------- 千日手用

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
  },
  computed: {
    IllegalInfo() { return IllegalInfo },

    illegal_app_state_human() {
      return this.order_clock_both_ok ? "対局中" : "検討中"
    },
  },
}
