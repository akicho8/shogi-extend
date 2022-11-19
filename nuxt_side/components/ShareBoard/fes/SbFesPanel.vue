<template lang="pug">
.columns.is-multiline.SbFesPanel
  .column.is-4
    .panel
      .panel-heading
        | 所属チームを自分で決める機能
      a.panel-block(href="/share-board?room_code=dev_room&user_name=a&fixed_member_names=a,b,c,d,e&fixed_order_state=to_o2_state&handle_name_validate=false&autoexec=client_vote_sample") 確認用の環境に変更する
      a.panel-block(@click="TheSb.odai_src_clear()") お題クリア
      a.panel-block(@click="TheSb.odai_src_set()") お題の初期値を入力
      a.panel-block(@click="TheSb.odai_modal_handle()") お題を作成する
      a.panel-block(@click="TheSb.fes_odai_share(Odai.from_json({subject: '(subject)', items: ['foo', 'bar']}))") 主催者が投票用の項目を配布する
      a.panel-block(@click="TheSb.fes_odai_delete()") 配送したお題の削除
      a.panel-block(@click="TheSb.fes_confirm_test()") クライアントは投票画面を表示して選択する
      a.panel-block(@click="TheSb.client_vote_reset()") 仮データ消去
      a.panel-block(@click="TheSb.client_vote_sample()") 仮データ投入
      a.panel-block(@click="TheSb.os_modal_handle()") 順番設定
      a.panel-block(@click="TheSb.auto_users_set2_test()") オーダー反映テスト
      a.panel-block(@click="TheSb.voted_hash_to_order_apply()") 「投票結果を順序に反映する」
  .column.is-4
    .panel
      .panel-heading
        | 内部変数
      pre.panel-block お題元 odai_src: {{TheSb.odai_src}}
      pre.panel-block お題受信 odai_fixed: {{TheSb.odai_fixed}}
      pre.panel-block 投票結果 voted_hash: {{TheSb.voted_hash}}
  .column.is-4
    .panel.assert_system_variable
      .panel-heading
        | [assert_system_variable]
      .panel-block odai_fixed.items:{{TheSb.odai_fixed.items}}
      .panel-block odai_fixed.subject:{{TheSb.odai_fixed.subject}}
      .panel-block odai_fixed.hash:{{TheSb.odai_fixed.hash}}
      .panel-block voted_hash:{{TheSb.voted_hash}}
</template>

<script>
import { support_child } from "../support_child.js"
import _ from "lodash"

export default {
  name: "SbFesPanel",
  mixins: [support_child],
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbFesPanel
</style>
