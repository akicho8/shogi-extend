<template lang="pug">
.the_room_question2
  .has-text-centered
    //- .status2
    //-   | {{app.q_turn_offset}}手目

  template(v-if="app.g_mode === 'g_mode1'")
    .status1.has-text-centered
      | {{app.q1_time_str}}
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="position_sfen_add(app.current_quest_init_sfen)"
      :summary_show="false"
      :setting_button_show="false"
      :size="'default'"
      :theme="'simple'"
      :human_side_key="'none'"
    )
    .kaitousuru_button.has-text-centered
      b-button(@click="app.g2_hayaosi_handle" type="is-primary" :disabled="app.config.ikkai_misuttara_mou_osenai && app.osenai_p") 解答する

  template(v-if="app.g_mode === 'g_mode2'")
    .has-text-centered
      | 操作中
    .has-text-centered
      .status1
        | {{app.q2_rest_seconds}}
      .status2
        | {{app.q_turn_offset}}手目
    shogi_player(
      :key="`quest_${app.question_index}`"
      :run_mode="'play_mode'"
      :kifu_body="position_sfen_add(app.current_quest_init_sfen)"
      :summary_show="false"
      :setting_button_show="false"
      :size="'default'"
      :sound_effect="true"
      :volume="0.5"
      :human_side_key="'both'"
      :controller_show="false"
      :theme="'simple'"
      @update:turn_offset="v => app.q_turn_offset = v"
      @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
    )
    //- :human_side_key="app.q2_rest_seconds === 0 ? 'none' : 'both'"
    .has-text-centered
      b-button(@click="app.g2_jikangire_handle") 諦める

  template(v-if="app.g_mode === 'g_mode3'")
    .has-text-centered
      | 相手が操作中です

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
  name: "the_room_question2",
  mixins: [
    support,
  ],
  created() {
    this.app.q1_interval_start()
  },
  beforeDestroy() {
    this.app.q1_interval_clear()
    this.app.q2_interval_stop()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_question2
  .tags_container
    margin-top: 0.7rem
  .kaitousuru_button
    margin-top: 0rem
</style>
