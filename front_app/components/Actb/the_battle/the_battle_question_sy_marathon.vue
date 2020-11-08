<template lang="pug">
.the_battle_question_sy_marathon
  .status_line2.has-text-centered.has-text-weight-bold
    | {{base.main_time_as_string}}
    template(v-if="base.debug_read_p")
      | ({{base.share_turn_offset}})
  MyShogiPlayer(
    :key="`quest_${base.question_index}`"
    ref="main_sp"
    :run_mode="'play_mode'"
    :kifu_body="base.current_question.init_sfen"
    :flip_if_white="true"
    :summary_show="false"
    :setting_button_show="false"
    :controller_show="true"
    :human_side_key="'both'"
    :theme="base.config.sp_theme"
    :size="base.config.sp_size"
    :vlayout="false"
    @update:turn_offset="v => base.share_turn_offset = v"
    @update:play_mode_advanced_full_moves_sfen="base.play_mode_advanced_full_moves_sfen_set"
  )
  .has-text-centered.mt-3
    b-button(@click="base.kotae_sentaku('timeout')" :disabled="base.main_interval_count < base.config.marathon_giveup_effective_seconds") あきらめる

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
  name: "the_battle_question_sy_marathon",
  mixins: [
    support_child,
  ],
  created() {
    this.base.main_interval_start()
  },
  beforeDestroy() {
    this.base.main_interval_clear()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_sy_marathon
</style>
