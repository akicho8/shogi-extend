<template lang="pug">
.columns.is-multiline.StopwatchDebugPanels.is-centered
  //- .column.is-2
  //-   .panel
  //-     .panel-heading
  //-       | 時間切れメソッド
  //-     a.panel-block(@click="base.cc_time_zero_callback") 最初のコールバック
  //-     a.panel-block(@click="base.cc_time_limit_modal_show_and_broadcast") 当事者は自分で発動＆BC
  //-     a.panel-block(@click="base.cc_delayed_time_limit_modal") 他者は数秒後発動
  //-     a.panel-block(@click="base.time_limit_modal_handle_if_not_exist") 受信
  //-     a.panel-block(@click="base.cc_auto_time_limit_delay_stop") 数秒後発動キャンセル
  //-     a.panel-block(@click="base.time_limit_modal_handle") モーダル
  //-     a.panel-block(@click="base.time_limit_modal_close") 閉じる
  //- .column.is-4
  //-   .panel
  //-     .panel-heading
  //-       | Rails側で作成 og:image 用
  //-     .panel-block
  //-       p.is_line_break_on {{$config.MY_SITE_URL + base.config.twitter_card_options.image}}
  //-       img.is-block(:src=`$config.MY_SITE_URL + base.config.twitter_card_options.image` width="256")
  //- .column.is-3
  //-   .panel
  //-     .panel-heading
  //-       | JSON
  //-     .panel-block
  //-       pre {{JSON.stringify(base.record, null, 4)}}
  .column.is-6.is-clipped
    .panel
      .panel-heading
        | $data
      .panel-block
        DebugPre {{base.$data}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "StopwatchDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.StopwatchDebugPanels
</style>
