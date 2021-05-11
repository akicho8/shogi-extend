<template lang="pug">
.ClockBoxInspector.box.has-background-primary-light
  p 対局時計 {{clock_box.human_status}}

  .level.is-mobile
    template(v-for="(e, i) in clock_box.single_clocks")
      .level-item.has-text-centered
        .active_current_bar(:class="e.bar_class" v-if="e.active_p && clock_box.timer")
        div
          p {{e.location.name}}
          p
            span.mx-1(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.to_time_format}}
            span.mx-1(v-if="e.initial_read_sec >= 1") {{e.read_sec}}
            span.mx-1(v-if="e.initial_extra_sec >= 1") {{e.extra_sec}}
          p {{e.initial_main_sec}} / {{e.initial_read_sec}} / {{e.initial_extra_sec}} / {{e.every_plus}} / {{e.minus_sec}}
          p active_p:{{e.active_p}} rest:{{e.rest}}

  .columns
    .column
      b-field(label="内部値")
        .control
          p turn: {{clock_box.turn}}
          p counter: {{clock_box.counter}}
          p zero_arrival: {{clock_box.zero_arrival}}
          p running_p: {{clock_box.running_p}}
          p speed: {{clock_box.speed}}
    .column
      b-field(label="コントローラー")
        .control
          .buttons
            b-button(@click="clock_box.tap_on('black')") ☗
            b-button(@click="clock_box.tap_on('white')") ☖
            b-button(@click="clock_box.location_to('black')") ☗
            b-button(@click="clock_box.location_to('white')") ☖
            b-button(@click="clock_box.clock_switch()"  icon-left="arrow-left-right")
            b-button(@click="clock_box.stop_handle()"   icon-left="stop")
            b-button(@click="clock_box.pause_handle()"  icon-left="pause")
            b-button(@click="clock_box.resume_handle()" icon-left="play-pause")
            b-button(@click="clock_box.play_handle()"   icon-left="play")
    .column
      b-field(label="時間操作")
        .control
          .buttons
            b-button(@click="clock_box.generation_next(-1)") -1
            b-button(@click="clock_box.generation_next(1)") +1
            b-button(@click="clock_box.generation_next(-60)") -60
            b-button(@click="clock_box.generation_next(60)") +60
    .column
      b-field(label="その他")
        .control
          .buttons
            b-button(@click="clock_box.reset()") RESET
            b-button(@click="clock_box.main_sec_set(3)") 両方残り3秒
      b-field(label="タイマーN倍速")
        b-slider(indicator v-model="clock_box.speed" :min="1" :max="1000")
</template>

<script>
export default {
  name: "ClockBoxInspector",
  props: {
    clock_box: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
.ClockBoxInspector
</style>
