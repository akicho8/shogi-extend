<template lang="pug">
.columns.is-multiline.SbDebugFes
  .column.is-3
    .panel
      .panel-heading
        | 投票(ホスト側)
      a.panel-block(href="?room_key=dev_room&user_name=a&fixed_member=a,b,c,d,e&fixed_order_state=to_o2_state&autoexec=client_vote_sample") 確認用の環境に変更する
      a.panel-block(@click="SB.quiz_src_clear()") お題初期化
      a.panel-block(@click="SB.quiz_src_sample()") お題サンプル投入
      a.panel-block(@click="SB.quiz_maker_handle()") お題メーカー
      a.panel-block(@click="SB.quiz_share(SB.Quiz.create({subject: 's', items: ['a', 'b']}))") お題配布
      a.panel-block(@click="SB.quiz_delete()") お題の削除
      a.panel-block(@click="SB.os_modal_open_handle()") 順番設定
      a.panel-block(@click="SB.voted_result_to_order_apply()") 結果を反映する
  .column.is-3
    .panel
      .panel-heading
        | 投票(クライアント側)
      a.panel-block(@click="SB.client_vote_reset()") 初期化
      a.panel-block(@click="SB.client_vote_sample()") 確認用データ投入
      a.panel-block(@click="SB.client_vote_modal_handle()") 投票
  .column.is-3
    .panel
      .panel-heading
        | 内部変数
      pre.panel-block [お題元] master_quiz: {{SB.master_quiz}}
      pre.panel-block [お題受信] received_quiz: {{SB.received_quiz}}
      pre.panel-block [投票結果] voted_result: {{SB.voted_result}}
  .column.is-3
    .panel.assert_var
      .panel-heading
        | [assert_var]
      .panel-block quiz_received_p:{{SB.quiz_received_p}}
      .panel-block received_quiz.items:{{SB.received_quiz.items}}
      .panel-block received_quiz.subject:{{SB.received_quiz.subject}}
      .panel-block received_quiz.unique_code:{{SB.received_quiz.unique_code}}
      .panel-block voted_result:{{SB.voted_result}}
      .panel-block 未投票者:{{SB.vote_yet_user_names}}
      .panel-block 全体人数:{{SB.room_user_names.length}}
      .panel-block 投票者数:{{SB.voted_result.count}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugFes",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugFes
  __css_keep__: 0
</style>
