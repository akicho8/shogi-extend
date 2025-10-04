<template lang="pug">
.panel.ClockBoxInspector
  .panel-heading
    | 対局時計 {{clock_box.human_status}}
  .panel-block
    .block
      .level.is-mobile
        template(v-for="(e, i) in clock_box.single_clocks")
          .level-item.has-text-centered(:class="`SingleClock${i}`")
            .active_current_bar(:class="e.rest_class" v-if="e.active_p && clock_box.timer")
            div
              p {{e.location.name}}
              p
                span.mx-1(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.main_sec_mmss}}
                span.mx-1(v-if="e.initial_read_sec >= 1") {{e.read_sec_mmss}}
                span.mx-1(v-if="e.initial_extra_sec >= 1") {{e.extra_sec_mmss}}
              p {{e.initial_main_sec}} / {{e.initial_read_sec}} / {{e.initial_extra_sec}} / {{e.every_plus}} / {{e.minus_sec}}
              .panel.assert_var
                .panel-block active_p:{{e.active_p}}
                .panel-block rest:{{e.rest}}
                .panel-block elapsed_sec:{{e.elapsed_sec}}
                .panel-block elapsed_sec_old:{{e.elapsed_sec_old}}
                .panel-block read_koreyori_count:{{e.read_koreyori_count}}
                .panel-block extra_koreyori_count:{{e.extra_koreyori_count}}
      .columns
        .column
          b-field(label="内部値")
            .control
              p elapsed_sec: {{clock_box.elapsed_sec}}
              p pause_or_play_p: {{clock_box.pause_or_play_p}}
              p timer: {{clock_box.timer}}
              p turn: {{clock_box.turn}}
              p any_zero_p: {{clock_box.any_zero_p}}
              p speed: {{clock_box.speed}}
              p play_count: {{clock_box.play_count}}
              p pause_count: {{clock_box.pause_count}}
              p resume_count: {{clock_box.resume_count}}
              p switch_count: {{clock_box.switch_count}}
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
  __css_keep__: 0
</style>
