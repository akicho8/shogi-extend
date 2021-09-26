<template lang="pug">
.KiwiBookShowDebugPanels.columns.is-multiline.is-centered
  .column.is-12
    .panel
      .panel-heading
        | book
      .panel-block
        pre {{pretty_inspect(base.book)}}

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
  //- .column.is-4
  //-   .panel
  //-     .panel-heading 操作
  //-     a.panel-block(@click="base.book_new_handle(base.my_records[0])") 動画管理登録
  //-
  //- .column.is-4
  //-   .panel
  //-     .panel-heading post_params
  //-     .panel-block
  //-       pre {{pretty_inspect(base.post_params)}}
  //- .column.is-4(v-if="base.response_hash")
  //-   .panel
  //-     .panel-heading response_hash
  //-     .panel-block
  //-       pre {{pretty_inspect(base.response_hash)}}
  //- .column.is-4(v-if="base.done_record")
  //-   .panel
  //-     .panel-heading done_record
  //-     .panel-block
  //-       pre {{pretty_inspect(base.done_record)}}
  //- .column.is-4(v-if="base.xaudio_list")
  //-   .panel
  //-     .panel-heading xaudio_list
  //-     .panel-block
  //-       pre {{pretty_inspect(base.xaudio_list)}}
  //-     .panel-block
  //-       pre {{pretty_inspect(base.xaudio_list_for_v_model)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiBookShowDebugPanels
</style>
