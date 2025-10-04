<template lang="pug">
.SbDebugClock.column.is-2
  .panel
    .panel-heading
      | 対局時計
    a.panel-block.cc_read_koreyori(@click="SB.cc_read_koreyori(30)") [発声] 秒読みモード突入時
    a.panel-block.cc_extra_koreyori(@click="SB.cc_extra_koreyori(30)") [発声] 考慮時間モード突入時
    a.panel-block.cc_byoyomi(@click="SB.cc_byoyomi(5)") [発声] 5 (残り5秒)
    a.panel-block.cc_interval_yomi(@click="SB.cc_interval_yomi(`20秒`)") [発声] 20秒〜
    a.panel-block.cc_interval_yomi(@click="SB.cc_pause_tick_callback(1, 0)") [発声] 一時停止後1分経過
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugClock",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugClock
  __css_keep__: 0
</style>
