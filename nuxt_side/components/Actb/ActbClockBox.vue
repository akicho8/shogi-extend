<template lang="pug">
.ActbClockBox
  ActbFooter(:base="base")
  .primary_header
    .header_center_title 対局時計
  .level.is-mobile
    template(v-for="(e, i) in clock_box.single_clocks")
      .level-item.has-text-centered
        div
          p.heading.is-size-1
            | {{Location.fetch(i).name}}
          p.title.is-size-1(:class="e.dom_class")
            | {{e.to_time_format}}
          p
            b-button.mt-4(@click="e.tap_on()" size="is-medium" :type="e.button_type") ボタン

  b-message
    | 1手毎に{{clock_box.params.every_plus}}秒加算

  .buttons.are-small.is-centered
    b-button(@click="clock_box.generation_next(-1)") -1
    b-button(@click="clock_box.generation_next(-60)") -60
    b-button(@click="clock_box.generation_next(1)") +1
    b-button(@click="clock_box.generation_next(60)") +60
    b-button(@click="clock_box.clock_switch()") 切り替え
    b-button(@click="clock_box.timer_start()") START
    b-button(@click="clock_box.timer_stop()") STOP
    b-button(@click="clock_box.params.every_plus = 5") フィッシャールール
    b-button(@click="clock_box.params.every_plus = 0") 通常ルール
    b-button(@click="clock_box.reset()") RESET
    b-button(@click="clock_box.value_set(3)") 両方残り3秒
</template>

<script>
import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { Location } from "shogi-player/components/models/location.js"

import { support_child } from "./support_child.js"

export default {
  name: "ActbClockBox",
  mixins: [
    support_child,
  ],

  data() {
    return {
      clock_box: null,
    }
  },
  created() {
    this.clock_box = new ClockBox()
  },
  beforeDestroy() {
    this.clock_box.timer_stop()
  },
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ActbClockBox
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
