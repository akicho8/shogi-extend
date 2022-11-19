// このスコープで this.odai_src に依存してはいけない

import ClientVoteModal from "./ClientVoteModal.vue"
import { OrderUnit } from "../order_mod/order_unit/order_unit.js"
import { Odai } from "./odai.js"

export const app_client_vote = {
  data() {
    return {
      odai_fixed:         Odai.create(), // 受信したお題情報
      voted_hash:         {},            // みんなの投票結果 (新しい odai_fixed を受けとるとリセットする)
      voted_latest_index: null,          // 自分が最後に投票した側
    }
  },
  methods: {
    // 新しいお題を受け取ったときに実行する
    client_vote_reset() {
      this.odai_fixed = Odai.create()
      this.voted_hash = {}
      this.voted_latest_index = null
    },

    client_vote_sample() {
      if (this.development_p) {
        this.odai_fixed = Odai.from_json({
          subject: "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
          items: [
            "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
            "1234567890123456789012345678901234567890",
          ],
        })
        this.voted_hash = {
          "ありす": 0,
          "ぼぶ": 0,
          "きゃろる": 1,
          "でいぶ": 1,
        }
      }
    },

    // お題を配送する。テストしやすいように odai は引数で受け取ること
    fes_odai_share(odai) {
      const params = {
        odai: odai, // odai.toJSON() が自動的に呼ばれる
      }
      this.ac_room_perform("fes_odai_share", params) // --> app/channels/share_board/room_channel.rb
    },
    fes_odai_share_broadcasted(params) {
      const new_odai = Object.freeze(Odai.from_json(params.odai))
      if (this.odai_fixed.hash != new_odai.hash) {
        this.debug_alert("新しいお題が届いたので投票結果をリセットする")
        this.client_vote_reset()
      }
      this.odai_fixed = new_odai
      this.fes_confirm_handle()
    },

    // 配送したお題の削除
    fes_odai_delete() {
      this.ac_room_perform("fes_odai_delete") // --> app/channels/share_board/room_channel.rb
    },
    fes_odai_delete_broadcasted(params) {
      this.client_vote_reset()
    },

    fes_confirm_test() {
      this.client_vote_sample()
      this.fes_confirm_handle()
    },
    fes_confirm_handle() {
      this.modal_card_open({
        component: ClientVoteModal,
      })
    },

    fes_vote_selected_share() {
      const params = {
        voted_latest_index: this.voted_latest_index,
      }
      this.ac_room_perform("fes_vote_selected_share", params) // --> app/channels/share_board/room_channel.rb
    },
    fes_vote_selected_share_broadcasted(params) {
      this.toast_ok(`${this.user_call_name(params.from_user_name)}が投票しました`)
      this.$set(this.voted_hash, params.from_user_name, params.voted_latest_index) // update(alice: 0)
    },

    auto_users_set2_test() {
      const order_unit = OrderUnit.create()
      order_unit.auto_users_set2(["a", "b", "c"], {a:0, b:1})
      console.log(order_unit.inspect)
    },

    // 投票結果を順番設定に適用する
    voted_hash_to_order_apply() {
      this.new_v.order_unit.auto_users_set2(this.room_user_names, this.voted_hash)
    },
  },
  computed: {
    voted_hash_exist_p() { return this.present_p(this.voted_hash) }, // 投票結果があるか？ (投票結果から順番に反映するボタンを出すか？)
  },
}
