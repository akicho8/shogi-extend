// |-----------------------------+------------------------------------------------------|
// | quiz_client_vote_reset      | 新しいお題を受け取ったときに実行する                 |
// | quiz_share(quiz)            | ホスト→クライアント お題を配送する                  |
// | quiz_delete                 | ホスト→クライアント お題を削除させる                |
// | quiz_vote_modal_handle      | クライアントが投票する                               |
// | quiz_voted_index_share           | クライアントが自分の投票の結果を配る                 |
// | voted_result_to_order_apply | 順番設定画面でホスト側が投票結果を順番設定に適用する |
// |-----------------------------+------------------------------------------------------|

// このスコープで this.master_quiz に依存してはいけない

import QuizVoteModal from "./QuizVoteModal.vue"
import { OrderFlow } from "../mod_order/order_flow/order_flow.js"
import { Quiz } from "./quiz.js"
import { QuizVotedResult } from "./quiz_voted_result.js"
import { GX } from "@/components/models/gx.js"

export const mod_quiz_client = {
  data() {
    return {
      quiz_received_p: false,             // お題情報を受信したか？
      received_quiz: Quiz.create(),       // 受信したお題情報
      quiz_voted_result: QuizVotedResult.create(), // みんなの投票結果 (新しい received_quiz を受けとるとリセットする)
      quiz_voted_index: null,           // 自分が最後に選択したもの (投票したとは限らない)
    }
  },
  methods: {
    // 新しいお題を受け取ったときに実行する
    quiz_client_vote_reset() {
      this.quiz_received_p = false
      this.received_quiz = Quiz.create()
      this.quiz_voted_result = QuizVotedResult.create()
      this.quiz_voted_index = null
    },

    // ホストからクライアントにお題を配送する。テストしやすいように quiz は引数で受け取ること
    quiz_share(quiz) {
      const params = { quiz: quiz }              // quiz.toJSON() が自動的に呼ばれる
      this.ac_room_perform("quiz_share", params) // --> app/channels/share_board/room_channel.rb
    },
    quiz_share_broadcasted(params) {
      const new_quiz = Object.freeze(Quiz.create(params.quiz))
      if (this.received_quiz.unique_code != new_quiz.unique_code) {
        this.debug_alert("新しいお題が届いたので投票結果をリセットする")
        this.quiz_client_vote_reset()
      }
      this.quiz_received_p = true
      this.received_quiz = new_quiz
      this.quiz_vote_modal_handle()
      this.ai_say_case_quiz(params, new_quiz)
    },

    // ホストからのお題と投票結果の削除命令を出す
    quiz_delete() {
      this.ac_room_perform("quiz_delete") // --> app/channels/share_board/room_channel.rb
    },
    quiz_delete_broadcasted(params) {
      this.quiz_client_vote_reset()
    },

    // お題に投票する
    async quiz_vote_modal_handle() {
      this.modal_card_open({
        component: QuizVoteModal,
        canCancel: [],
      })
      await this.sfx_play("se_deden")
      this.sb_talk(this.received_quiz.subject)
    },

    // 投票結果をみんなに伝える
    quiz_voted_index_share() {
      const params = {
        quiz_voted_index: this.quiz_voted_index,
      }
      this.ac_room_perform("quiz_voted_index_share", params) // --> app/channels/share_board/room_channel.rb
    },
    quiz_voted_index_share_broadcasted(params) {
      this.sfx_play("se_pipopipo")
      this.toast_ok(`${this.user_call_name(params.from_user_name)}が投票しました`)
      this.al_add({...params, label: "投票完了"})
      this.quiz_voted_result = this.quiz_voted_result.merge({[params.from_user_name]: params.quiz_voted_index})
    },

    // 順番設定画面でホスト側(別にホストの人でなくてもいいが)が投票結果を順番設定に適用する
    voted_result_to_order_apply() {
      GX.assert(GX.present_p(this.order_draft), "GX.present_p(this.order_draft)")
      GX.assert(GX.present_p(this.order_draft.order_flow), "GX.present_p(this.order_draft.order_flow)")
      this.order_draft.order_flow.auto_users_set_with_voted_hash(this.room_user_names, this.quiz_voted_result.to_h) // 反映
      this.order_draft.order_flow.teams_each_shuffle() // チーム内シャッフル実行
    },

    // private

    client_vote_sample() {
      this.quiz_received_p = true
      this.received_quiz = Quiz.create({
        subject: "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
        items: [
          "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
          "1234567890123456789012345678901234567890",
        ],
      })
      this.quiz_voted_result = QuizVotedResult.create({
        "ありす": 0,
        "ぼぶ": 0,
        "きゃろる": 1,
        "でいぶ": 1,
      })
    },
  },
  computed: {
    // まだ投票していない人たち
    vote_yet_user_names() {
      // return ["あああ", "いいいいいいいいい", "12345678901234567890123456789012345678901234567890123456789012345678901234567890", "１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０"]
      return GX.ary_minus(this.room_user_names, this.quiz_voted_result.user_names)
    },
  },
}
