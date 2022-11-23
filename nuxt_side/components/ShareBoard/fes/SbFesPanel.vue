<template lang="pug">
.columns.is-multiline.SbFesPanel
  .column.is-3
    .panel
      .panel-heading
        | 投票(ホスト側)
      a.panel-block(href="/share-board?room_code=dev_room&user_name=a&fixed_member_names=a,b,c,d,e&fixed_order_state=to_o2_state&handle_name_validate=false&autoexec=client_vote_sample") 確認用の環境に変更する
      a.panel-block(@click="TheSb.odai_src_clear()") お題初期化
      a.panel-block(@click="TheSb.odai_src_sample()") お題サンプル投入
      a.panel-block(@click="TheSb.odai_maker_handle()") お題メーカー
      a.panel-block(@click="TheSb.odai_share(TheSb.Odai.create({subject: 's', items: ['a', 'b']}))") お題配布
      a.panel-block(@click="TheSb.odai_delete()") お題の削除
      a.panel-block(@click="TheSb.os_modal_handle()") 順番設定
      a.panel-block(@click="TheSb.voted_result_to_order_apply()") 結果を反映する
  .column.is-3
    .panel
      .panel-heading
        | 投票(クライアント側)
      a.panel-block(@click="TheSb.client_vote_reset()") 初期化
      a.panel-block(@click="TheSb.client_vote_sample()") 確認用データ投入
      a.panel-block(@click="TheSb.client_vote_modal_handle()") 投票
  .column.is-3
    .panel
      .panel-heading
        | 内部変数
      pre.panel-block [お題元] master_odai: {{TheSb.master_odai}}
      pre.panel-block [お題受信] received_odai: {{TheSb.received_odai}}
      pre.panel-block [投票結果] voted_result: {{TheSb.voted_result}}
  .column.is-3
    .panel.assert_system_variable
      .panel-heading
        | [assert_system_variable]
      .panel-block received_odai.items:{{TheSb.received_odai.items}}
      .panel-block received_odai.subject:{{TheSb.received_odai.subject}}
      .panel-block received_odai.unique_code:{{TheSb.received_odai.unique_code}}
      .panel-block voted_result:{{TheSb.voted_result}}
      .panel-block 全体人数:{{TheSb.room_user_names.length}}
      .panel-block 投票者数:{{TheSb.voted_result.count}}
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
