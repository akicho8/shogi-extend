<template lang="pug">
.ActbBattleQuestionSySingleton
  //- .has-text-centered
  //-   //- .status2
  //-   //-   | {{base.share_turn_offset}}手目

  template(v-if="base.x_mode === 'x1_think'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{base.main_time_as_string}}
    CustomShogiPlayer(
      :sp_mobile_style="'is_mobile_style_off'"
      :run_mode="'play_mode'"
      :kifu_body="base.current_question.init_sfen"
      :flip_if_white="true"
      :summary_show="false"
      :setting_button_show="false"
      :human_side_key="'none'"
    )
    .wakatta_button.has-text-centered.mt-3
      b-button.has-text-weight-bold(@click="base.answer_button_push_handle(false)" type="is-primary" size="is-medium" :disabled="base.current_mi.otetuki_p(base.current_question.id)") わかった
      b-button.has-text-weight-bold(@click="base.skip_handle(false)" v-if="false") SKIP

  template(v-if="base.x_mode === 'x2_play'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{base.ops_rest_seconds}}
      template(v-if="base.debug_read_p")
        | ({{base.share_turn_offset}})
    CustomShogiPlayer(
      :sp_mobile_style="'is_mobile_style_off'"
      :key="`quest_${base.question_index}`"
      :run_mode="'play_mode'"
      :kifu_body="base.current_question.init_sfen"
      :flip_if_white="true"
      :summary_show="false"
      :setting_button_show="false"
      :human_side_key="'both'"
      :controller_show="false"
      @update:turn_offset="base.q_turn_offset_set"
      @update:play_mode_advanced_full_moves_sfen="base.play_mode_advanced_full_moves_sfen_set"
    )
    .mt-3.has-text-centered
      b-button(@click="base.x2_play_timeout_handle(false)" size="is-medium" :disabled="base.ops_interval_total < base.config.singleton_giveup_effective_seconds") あきらめる

  template(v-if="base.x_mode === 'x3_see'")
    .status_line2.has-text-centered.has-text-weight-bold
      | 相手が操作中 ({{base.share_turn_offset}}手目)
    CustomShogiPlayer(
      :sp_mobile_style="'is_mobile_style_off'"
      :run_mode="'play_mode'"
      :kifu_body="base.share_sfen"
      :flip_if_white="true"
      :start_turn="-1"
      :summary_show="false"
      :setting_button_show="false"
      :sound_effect="false"
      :human_side_key="'none'"
      :controller_show="false"
      @update:turn_offset="v => base.share_turn_offset = v"
    )
    .mt-3.has-text-centered
      b-button.is-invisible

  .has-text-centered.mt-3(v-if="base.debug_read_p")
    //- p 難易度:{{base.current_question.difficulty_level}}
    b-taglist.is-centered
      b-tag(v-if="base.current_question.title") {{base.current_question.title}}
      b-tag(v-if="base.current_question.source_author") {{base.current_question.source_author}}
      b-tag(v-if="!base.current_question.source_author") {{base.current_question.user.name}}作
      b-tag(v-if="base.current_question.hint_desc") {{base.current_question.hint_desc}}
      b-tag(v-if="base.current_question.difficulty_level && base.current_question.difficulty_level >= 1")
        template(v-for="i in base.current_question.difficulty_level")
          | ★
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbBattleQuestionSySingleton",
  mixins: [
    support_child,
  ],
  created() {
    this.base.main_interval_start()
  },
  beforeDestroy() {
    this.base.main_interval_clear()
    this.base.ops_interval_stop()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBattleQuestionSySingleton
</style>
