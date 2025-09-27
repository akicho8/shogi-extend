// |-----------------------------+------------------------------------------------------|
// | client_vote_reset           | 新しいお題を受け取ったときに実行する                 |
// | odai_share(odai)            | ホスト→クライアント お題を配送する                  |
// | odai_delete                 | ホスト→クライアント お題を削除させる                |
// | client_vote_modal_handle    | クライアントが投票する                               |
// | vote_select_share           | クライアントが自分の投票の結果を配る                 |
// | voted_result_to_order_apply | 順番設定画面でホスト側が投票結果を順番設定に適用する |
// |-----------------------------+------------------------------------------------------|

// このスコープで this.master_odai に依存してはいけない

import ClientVoteModal from "./ClientVoteModal.vue"
import { OrderUnit } from "../order_mod/order_unit/order_unit.js"
import { Odai } from "./odai.js"
import { VotedResult } from "./voted_result.js"
import { Gs } from "@/components/models/gs.js"

export const mod_client_vote = {
  data() {
    return {
      odai_received_p: false,              // お題情報を受信したか？
      received_odai: Odai.create(),       // 受信したお題情報
      voted_result: VotedResult.create(), // みんなの投票結果 (新しい received_odai を受けとるとリセットする)
      voted_latest_index: null,           // 自分が最後に選択したもの (投票したとは限らない)
    }
  },
  methods: {
    // 新しいお題を受け取ったときに実行する
    client_vote_reset() {
      this.odai_received_p = false
      this.received_odai = Odai.create()
      this.voted_result = VotedResult.create()
      this.voted_latest_index = null
    },

    // ホストからクライアントにお題を配送する。テストしやすいように odai は引数で受け取ること
    odai_share(odai) {
      const params = { odai: odai }              // odai.toJSON() が自動的に呼ばれる
      this.ac_room_perform("odai_share", params) // --> app/channels/share_board/room_channel.rb
    },
    odai_share_broadcasted(params) {
      const new_odai = Object.freeze(Odai.create(params.odai))
      if (this.received_odai.unique_code != new_odai.unique_code) {
        this.debug_alert("新しいお題が届いたので投票結果をリセットする")
        this.client_vote_reset()
      }
      this.odai_received_p = true
      this.received_odai = new_odai
      this.client_vote_modal_handle()
      this.ai_say_case_odai(params, new_odai)
    },

    // ホストからのお題と投票結果の削除命令を出す
    odai_delete() {
      this.ac_room_perform("odai_delete") // --> app/channels/share_board/room_channel.rb
    },
    odai_delete_broadcasted(params) {
      this.client_vote_reset()
    },

    // お題に投票する
    client_vote_modal_handle() {
      this.sfx_play("se_deden")
      Gs.delay_block(0.6, () => this.sb_talk(this.received_odai.subject))
      this.modal_card_open({
        component: ClientVoteModal,
        canCancel: [],
      })
    },

    // 投票結果をみんなに伝える
    vote_select_share() {
      const params = {
        voted_latest_index: this.voted_latest_index,
      }
      this.ac_room_perform("vote_select_share", params) // --> app/channels/share_board/room_channel.rb
    },
    vote_select_share_broadcasted(params) {
      this.sfx_play("se_pipopipo")
      this.toast_ok(`${this.user_call_name(params.from_user_name)}が投票しました`)
      this.al_add({...params, label: "投票完了"})
      this.voted_result = this.voted_result.merge({[params.from_user_name]: params.voted_latest_index})
    },

    // 順番設定画面でホスト側(別にホストの人でなくてもいいが)が投票結果を順番設定に適用する
    voted_result_to_order_apply() {
      Gs.assert(Gs.present_p(this.new_v), "Gs.present_p(this.new_v)")
      Gs.assert(Gs.present_p(this.new_v.order_unit), "Gs.present_p(this.new_v.order_unit)")
      this.new_v.order_unit.auto_users_set_with_voted_hash(this.room_user_names, this.voted_result.to_h) // 反映
      this.new_v.order_unit.teams_each_shuffle() // チーム内シャッフル実行
    },

    // private

    client_vote_sample() {
      this.odai_received_p = true
      this.received_odai = Odai.create({
        subject: "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
        items: [
          "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
          "1234567890123456789012345678901234567890",
        ],
      })
      this.voted_result = VotedResult.create({
        "ありす": 0,
        "ぼぶ": 0,
        "きゃろる": 1,
        "でいぶ": 1,
      })
    },
  },
}
