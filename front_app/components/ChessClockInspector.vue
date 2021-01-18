<template lang="pug">
.ChessClockInspector.box
  p 対局時計 {{chess_clock.human_status}}

  .level.is-mobile
    template(v-for="(e, i) in chess_clock.single_clocks")
      .level-item.has-text-centered
        .active_current_bar(:class="e.bar_class" v-if="e.active_p && chess_clock.timer")
        div
          p {{e.location.name}}
          p
            span.mx-1(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.to_time_format}}
            span.mx-1(v-if="e.initial_read_sec >= 1") {{e.read_sec}}
            span.mx-1(v-if="e.initial_extra_sec >= 1") {{e.extra_sec}}
          p {{e.initial_main_sec}} / {{e.initial_read_sec}} / {{e.initial_extra_sec}} / {{e.every_plus}}
          p active_p:{{e.active_p}} rest:{{e.rest}}

  .columns
    .column
      b-field(label="内部値")
        .control
          p turn: {{chess_clock.turn}}
          p counter: {{chess_clock.counter}}
          p zero_arrival: {{chess_clock.zero_arrival}}
          p running_p: {{chess_clock.running_p}}
          p speed: {{chess_clock.speed}}
    .column
      b-field(label="コントローラー")
        .control
          .buttons
            b-button(@click="chess_clock.clock_switch()"  icon-left="arrow-left-right")
            b-button(@click="chess_clock.stop_handle()"   icon-left="stop")
            b-button(@click="chess_clock.pause_handle()"  icon-left="pause")
            b-button(@click="chess_clock.resume_handle()" icon-left="play-pause")
            b-button(@click="chess_clock.play_handle()"   icon-left="play")
    .column
      b-field(label="時間操作")
        .control
          .buttons
            b-button(@click="chess_clock.generation_next(-1)") -1
            b-button(@click="chess_clock.generation_next(1)") +1
            b-button(@click="chess_clock.generation_next(-60)") -60
            b-button(@click="chess_clock.generation_next(60)") +60
    .column
      b-field(label="その他")
        .control
          .buttons
            b-button(@click="chess_clock.reset()") RESET
            b-button(@click="chess_clock.main_sec_set(3)") 両方残り3秒
      b-field(label="タイマーN倍速")
        b-slider(indicator v-model="chess_clock.speed" :min="1" :max="1000")
</template>

<script>
export default {
  name: "ChessClockInspector",
  props: {
    chess_clock: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
.ChessClockInspector
</style>
