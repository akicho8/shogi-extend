<template lang="pug">
.the_battle_question_singleton_rule
  .has-text-centered
    //- .status2
    //-   | {{app.q_turn_offset}}手目

  template(v-if="app.x_mode === 'x1_thinking'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{app.q1_time_str}}
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="app.c_quest.init_sfen"
      :summary_show="false"
      :setting_button_show="false"
      :size="'default'"
      :theme="'real'"
      :human_side_key="'none'"
    )
    .kaitousuru_button.has-text-centered
      b-button.has-text-weight-bold(@click="app.wakatta_handle(false)" type="is-primary" :disabled="app.config.otetsuki_enabled && app.answer_button_disable_p") わかった

  template(v-if="app.x_mode === 'x2_play'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{app.q2_rest_seconds}}
      template(v-if="app.debug_mode_p")
        | ({{app.q_turn_offset}})
    shogi_player(
      :key="`quest_${app.question_index}`"
      :run_mode="'play_mode'"
      :kifu_body="app.c_quest.init_sfen"
      :summary_show="false"
      :setting_button_show="false"
      :size="'default'"
      :sound_effect="false"
      :volume="0.5"
      :human_side_key="'both'"
      :controller_show="false"
      :theme="'real'"
      @update:turn_offset="app.q_turn_offset_set"
      @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
    )
    .akirameru_button.has-text-centered(v-if="app.debug_mode_p")
      b-button.has-text-weight-bold(@click="app.x2_play_timeout_handle(false)" size="is-large") 諦める

  template(v-if="app.x_mode === 'x3_see'")
    .status_line2.has-text-centered.has-text-weight-bold
      | 相手が操作中 ({{app.q_turn_offset}}手目)
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="app.share_sfen"
      :start_turn="-1"
      :summary_show="false"
      :setting_button_show="false"
      :size="'default'"
      :sound_effect="true"
      :volume="0.5"
      :human_side_key="'none'"
      :controller_show="false"
      :theme="'real'"
      @update:turn_offset="v => app.q_turn_offset = v"
    )

  .has-text-centered.tags_container(v-if="app.debug_mode_p")
    //- p 難易度:{{app.c_quest.difficulty_level}}
    b-taglist.is-centered
      b-tag(v-if="app.c_quest.title") {{app.c_quest.title}}
      b-tag(v-if="app.c_quest.other_author") {{app.c_quest.other_author}}
      b-tag(v-if="!app.c_quest.other_author") {{app.c_quest.user.name}}作
      b-tag(v-if="app.c_quest.hint_desc") {{app.c_quest.hint_desc}}
      b-tag(v-if="app.c_quest.difficulty_level && app.c_quest.difficulty_level >= 1")
        template(v-for="i in app.c_quest.difficulty_level")
          | ★
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_battle_question_singleton_rule",
  mixins: [
    support,
  ],
  created() {
    this.app.main_interval_start()
  },
  beforeDestroy() {
    this.app.main_interval_clear()
    this.app.q2_interval_stop()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_singleton_rule
  .tags_container
    margin-top: 0.7rem
  .kaitousuru_button
    margin-top: 0.7rem
  .akirameru_button
    margin-top: 0.7rem
</style>
