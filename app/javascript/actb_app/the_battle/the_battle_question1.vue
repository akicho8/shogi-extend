<template lang="pug">
.the_battle_question1
  .status_line2.has-text-centered.has-text-weight-bold
    | {{app.q1_time_str}}
    template(v-if="development_p")
      | ({{app.q_turn_offset}})
  shogi_player(
    :key="`quest_${app.question_index}`"
    ref="main_sp"
    :run_mode="'play_mode'"
    :kifu_body="app.c_quest.full_init_sfen"
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

  .has-text-centered.tags_container(v-if="development_p")
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
  name: "the_battle_question1",
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
.the_battle_question1
  .tags_container
    margin-top: 0.7rem
  .kaitousuru_button
    margin-top: 0rem
</style>
