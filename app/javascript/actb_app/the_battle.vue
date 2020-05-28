<template lang="pug">
.the_battle
  debug_print(:vars="['app.sub_mode', 'app.members_hash', 'app.question_index', 'app.x_mode', 'app.answer_button_disable_p']" oneline)

  .vs_info.is-flex
    template(v-for="(membership, i) in app.battle.memberships")
      .user_block.user_container.is-flex
        template(v-if="membership.rensho_count >= 2")
          .rensho_count
            | {{membership.rensho_count}}連勝中！
        figure.image.is-32x32
          img.is-rounded(:src="membership.user.avatar_path")
        .user_name.has-text-weight-bold
          | {{membership.user.name}}

        template(v-if="app.battle.rule_key === 'marathon_rule'")
          .user_quest_index2
            | {{ox_list(membership).length}} / {{app.battle.best_questions.length}}
          .user_quest_index
            template(v-if="progress_list2(membership).length === 0")
              | &nbsp;
            template(v-for="ox_mark_key in progress_list2(membership)")
              template(v-if="ox_mark_key === 'correct'")
                b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
              template(v-if="ox_mark_key === 'mistake'")
                b-icon(icon="close" size="is-small" type="is-success")

        template(v-if="app.battle.rule_key === 'singleton_rule' || app.battle.rule_key === 'hybrid_rule'")
          .user_quest_index2
            | {{x_score(membership)}}
          .user_quest_index
            template(v-if="progress_list2(membership).length === 0")
              | &nbsp;
            template(v-for="ox_mark_key in progress_list2(membership)")
              template(v-if="ox_mark_key === 'correct'")
                b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
              template(v-if="ox_mark_key === 'mistake'")
                b-icon(icon="close" size="is-small" type="is-success")

      template(v-if="i === 0")
        .vs_block.is-1.is-flex.has-text-weight-bold.is-size-4
          | vs

  template(v-if="app.sub_mode === 'deden_mode'")
    .deden_mode_container.has-text-centered
      | {{app.question_index + 1}}問目

  template(v-if="app.sub_mode === 'operation_mode' || app.sub_mode === 'correct_mode'")
    the_battle_question1(v-if="app.battle.rule_key === 'marathon_rule' || app.battle.rule_key === 'hybrid_rule'")
    the_battle_question2(v-if="app.battle.rule_key === 'singleton_rule'")

  template(v-if="app.sub_mode === 'mistake_mode'")
    .mistake_mode_container.has-text-centered
      | 時間切れ

  template(v-if="development_p")
    .columns
      .column
        .buttons.are-small.is-centered
          b-button(@click="app.kotae_sentaku('correct')") 正解
          b-button(@click="app.kotae_sentaku('mistake')") 時間切れ
          b-button(@click="app.g2_hayaosi_handle()") シングルトンで解答
          b-button(@click="app.g2_jikangire_handle()") シングルトンで誤答
</template>

<script>
import { support } from "./support.js"
import dayjs from "dayjs"
import the_battle_question1 from "./the_battle_question1.vue"
import the_battle_question2 from "./the_battle_question2.vue"

export default {
  name: "the_battle",
  mixins: [
    support,
  ],
  components: {
    the_battle_question1,
    the_battle_question2,
  },
  created() {
    this.app.lobby_close()
  },
  methods: {
    ox_list(membership) {
      return this.app.members_hash[membership.id].ox_list
    },
    progress_list2(membership) {
      return _.takeRight(this.ox_list(membership), this.app.config.progress_list_take_display_count)
    },
    x_score(membership) {
      return this.app.members_hash[membership.id].x_score
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_battle
  .deden_mode_container
    font-size: 5rem
  .mistake_mode_container
    font-size: 5rem
  .vs_info
    justify-content: center
    align-items: center
    .user_block
      width: 100%
      .user_quest_index
    .vs_block
      flex-direction: column
      justify-content: center
      align-items: center
</style>
