<template lang="pug">
.ActbChessClock
  ActbFooter(:base="base")
  .primary_header
    .header_center_title 対局時計
  .level.is-mobile
    template(v-for="(e, i) in chess_clock.single_clocks")
      .level-item.has-text-centered
        div
          p.heading.is-size-1
            | {{Location.fetch(i).name}}
          p.title.is-size-1(:class="e.dom_class")
            | {{e.to_time_format}}
          p
            b-button.mt-4(@click="e.tap_and_auto_start_handle()" size="is-medium" :type="e.button_type") ボタン

  b-message
    | 1手毎に{{chess_clock.params.every_plus}}秒加算

  .buttons.are-small.is-centered
    b-button(@click="chess_clock.generation_next(-1)") -1
    b-button(@click="chess_clock.generation_next(-60)") -60
    b-button(@click="chess_clock.generation_next(1)") +1
    b-button(@click="chess_clock.generation_next(60)") +60
    b-button(@click="chess_clock.clock_switch()") 切り替え
    b-button(@click="chess_clock.timer_start()") START
    b-button(@click="chess_clock.timer_stop()") STOP
    b-button(@click="chess_clock.params.every_plus = 5") フィッシャールール
    b-button(@click="chess_clock.params.every_plus = 0") 通常ルール
    b-button(@click="chess_clock.reset()") RESET
    b-button(@click="chess_clock.value_set(3)") 両方残り3秒
</template>

<script>
import { ChessClock   } from "@/components/models/ChessClock.js"
import { Location } from "shogi-player/components/models/location.js"

import { support_child } from "./support_child.js"

export default {
  name: "ActbChessClock",
  mixins: [
    support_child,
  ],

  data() {
    return {
      chess_clock: null,
    }
  },
  created() {
    this.chess_clock = new ChessClock()
  },
  beforeDestroy() {
    this.chess_clock.timer_stop()
  },
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ActbChessClock
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
