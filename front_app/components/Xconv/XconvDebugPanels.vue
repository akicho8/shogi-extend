<template lang="pug">
.columns.is-multiline.XconvDebugPanels.is-centered
  //- .column.is-2
  //-   .panel
  //-     .panel-heading
  //-       | 時間切れメソッド
  //-     a.panel-block(@click="base.cc_time_zero_callback") 最初のコールバック
  //-     a.panel-block(@click="base.cc_time_limit_modal_show_and_broadcast") 当事者は自分で発動＆BC
  //-     a.panel-block(@click="base.cc_delayed_time_limit_modal") 他者は数秒後発動
  //-     a.panel-block(@click="base.time_limit_modal_handle_if_not_exist") 受信
  //-     a.panel-block(@click="base.cc_auto_time_limit_delay_stop") 数秒後発動キャンセル
  //-     a.panel-block(@click="base.time_limit_modal_handle('default')") モーダル(通常)
  //-     a.panel-block(@click="base.time_limit_modal_handle('judge')") モーダル(推測)
  //-     a.panel-block(@click="base.time_limit_modal_close") 閉じる
  .column.is-4
    .panel
      .panel-heading post_params
      .panel-block
        pre {{JSON.stringify(base.post_params, null, 4)}}
  .column.is-4(v-if="base.response_hash")
    .panel
      .panel-heading response_hash
      .panel-block
        pre {{JSON.stringify(base.response_hash, null, 4)}}
  .column.is-4(v-if="base.done_record")
    .panel
      .panel-heading done_record
      .panel-block
        pre {{JSON.stringify(base.done_record, null, 4)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvDebugPanels
</style>
