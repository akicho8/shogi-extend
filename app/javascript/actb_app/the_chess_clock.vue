<template lang="pug">
.the_chess_clock
  the_footer
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
            b-button.mt-4(@click="e.tap_and_auto_start_handle()" size="is-large" :type="e.button_type") ボタン
          p
            | disabled: {{e.disabled_p}}

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
import { ChessClock } from "./models/chess_clock.js"
import Location from "shogi-player/src/location.js"

import { support } from "./support.js"
import the_footer from "./the_footer.vue"

export default {
  name: "the_chess_clock",
  mixins: [
    support,
  ],
  components: {
    the_footer,
  },
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
.the_chess_clock
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
