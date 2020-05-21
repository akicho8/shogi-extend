<template lang="pug">
.the_room_question1
  .has-text-centered
    .status1
      | {{app.q1_time_str}}
    .status2
      | {{app.q_turn_offset}}手目
  shogi_player(
    :key="`quest_${app.question_index}`"
    ref="main_sp"
    :run_mode="'play_mode'"
    :kifu_body="position_sfen_add(app.current_quest_init_sfen)"
    :summary_show="false"
    :setting_button_show="false"
    :size="'default'"
    :sound_effect="true"
    :volume="0.5"
    :controller_show="true"
    :human_side_key="'both'"
    :theme="'simple'"
    :vlayout="false"
    @update:turn_offset="v => app.q_turn_offset = v"
    @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
  )

  .has-text-centered.tags_container
    //- p 難易度:{{app.q_record.difficulty_level}}
    b-taglist.is-centered
      b-tag(v-if="app.q_record.title") {{app.q_record.title}}
      b-tag(v-if="app.q_record.source_desc") {{app.q_record.source_desc}}
      b-tag(v-if="!app.q_record.source_desc") {{app.q_record.user.name}}作
      b-tag(v-if="app.q_record.hint_description") {{app.q_record.hint_description}}
      b-tag(v-if="app.q_record.difficulty_level && app.q_record.difficulty_level >= 1")
        template(v-for="i in app.q_record.difficulty_level")
          | ★
</template>

<script>
import support from "./support.js"

export default {
  name: "the_room_question1",
  mixins: [
    support,
  ],
  created() {
    this.app.q1_interval_start()
  },
  beforeDestroy() {
    this.app.q1_interval_clear()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_question1
  .tags_container
    margin-top: 0.7rem
  .kaitousuru_button
    margin-top: 0rem
</style>
