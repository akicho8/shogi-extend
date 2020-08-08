<template lang="pug">
.the_battle_question_sy_singleton
  .has-text-centered
    | {{app.ops_interval_total}}

    //- .status2
    //-   | {{app.share_turn_offset}}手目

  template(v-if="app.x_mode === 'x1_think'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{app.main_time_as_string}}
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="app.current_question.init_sfen"
      :flip_if_white="true"
      :summary_show="false"
      :setting_button_show="false"
      :theme="app.config.sp_theme"
      :size="app.config.sp_size"
      :human_side_key="'none'"
    )
    .wakatta_button.has-text-centered.mt-3
      b-button.has-text-weight-bold(@click="app.wakatta_handle(false)" type="is-primary" size="is-large" :disabled="app.current_mi.otetuki_p(app.current_question.id)") わかった
      b-button.has-text-weight-bold(@click="app.skip_handle(false)" v-if="false") SKIP

  template(v-if="app.x_mode === 'x2_play'")
    .status_line2.has-text-centered.has-text-weight-bold
      | {{app.ops_rest_seconds}}
      template(v-if="app.debug_read_p")
        | ({{app.share_turn_offset}})
    shogi_player(
      :key="`quest_${app.question_index}`"
      :run_mode="'play_mode'"
      :kifu_body="app.current_question.init_sfen"
      :flip_if_white="true"
      :summary_show="false"
      :setting_button_show="false"
      :sound_effect="true"
      :volume="0.5"
      :human_side_key="'both'"
      :controller_show="false"
      :theme="app.config.sp_theme"
      :size="app.config.sp_size"
      @update:turn_offset="app.q_turn_offset_set"
      @update:play_mode_advanced_full_moves_sfen="app.play_mode_advanced_full_moves_sfen_set"
    )
    .mt-3.has-text-centered
      b-button(@click="app.x2_play_timeout_handle(false)" size="is-large" :disabled="app.ops_interval_total < app.config.singleton_giveup_effective_seconds") あきらめる

  template(v-if="app.x_mode === 'x3_see'")
    .status_line2.has-text-centered.has-text-weight-bold
      | 相手が操作中 ({{app.share_turn_offset}}手目)
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="app.share_sfen"
      :flip_if_white="true"
      :start_turn="-1"
      :summary_show="false"
      :setting_button_show="false"
      :sound_effect="false"
      :volume="0.5"
      :human_side_key="'none'"
      :controller_show="false"
      :theme="app.config.sp_theme"
      :size="app.config.sp_size"
      @update:turn_offset="v => app.share_turn_offset = v"
    )
    .mt-3.has-text-centered
      b-button.is-invisible

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
  name: "the_battle_question_sy_singleton",
  mixins: [
    support,
  ],
  created() {
    this.app.main_interval_start()
  },
  beforeDestroy() {
    this.app.main_interval_clear()
    this.app.ops_interval_stop()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_sy_singleton
</style>
