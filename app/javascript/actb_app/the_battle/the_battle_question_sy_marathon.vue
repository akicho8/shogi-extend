<template lang="pug">
.the_battle_question_sy_marathon
  .status_line2.has-text-centered.has-text-weight-bold
    | {{app.main_time_as_string}}
    template(v-if="app.debug_read_p")
      | ({{app.share_turn_offset}})
  shogi_player(
    :key="`quest_${app.question_index}`"
    ref="main_sp"
    :run_mode="'play_mode'"
    :kifu_body="app.current_question.init_sfen"
    :flip="flip_if_white(app.current_question.init_sfen)"
    :summary_show="false"
    :setting_button_show="false"
    :sound_effect="true"
    :volume="0.5"
    :controller_show="true"
    :human_side_key="'both'"
    :theme="app.config.sp_theme"
    :size="app.config.sp_size"
    :vlayout="false"
    @update:turn_offset="v => app.share_turn_offset = v"
    @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
  )
  .has-text-centered.mt-3
    b-button(@click="app.kotae_sentaku('timeout')" :disabled="app.main_interval_count < app.config.akirameru_deru_jikan") あきらめる

  .has-text-centered.mt-3(v-if="app.debug_read_p")
    //- p 難易度:{{app.current_question.difficulty_level}}
    b-taglist.is-centered
      b-tag(v-if="app.current_question.title") {{app.current_question.title}}
      b-tag(v-if="app.current_question.source_author") {{app.current_question.source_author}}
      b-tag(v-if="!app.current_question.source_author") {{app.current_question.user.name}}作
      b-tag(v-if="app.current_question.hint_desc") {{app.current_question.hint_desc}}
      b-tag(v-if="app.current_question.difficulty_level && app.current_question.difficulty_level >= 1")
        template(v-for="i in app.current_question.difficulty_level")
          | ★
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_battle_question_sy_marathon",
  mixins: [
    support,
  ],
  created() {
    this.app.main_interval_start()
  },
  beforeDestroy() {
    this.app.main_interval_clear()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_sy_marathon
</style>
