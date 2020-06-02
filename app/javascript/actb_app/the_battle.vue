<template lang="pug">
.the_battle
  debug_print(:vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode', 'app.answer_button_disable_p', 'app.battle.best_questions.length']" oneline)

  .vs_container.is-flex
    template(v-for="(membership, i) in app.battle.memberships")
      the_battle_membership(:membership="membership" :key="membership.id")
      .is-1.has-text-weight-bold.is-size-4.has-text-grey-light(v-if="i === 0") vs

  template(v-if="app.sub_mode === 'deden_mode'")
    .deden_mode_container.has-text-centered
      | {{app.question_index + 1}}問目

  template(v-if="app.sub_mode === 'operation_mode' || app.sub_mode === 'correct_mode'")
    the_battle_question1(v-if="app.battle.rule.key === 'marathon_rule' || app.battle.rule.key === 'hybrid_rule'")
    the_battle_question2(v-if="app.battle.rule.key === 'singleton_rule'")

  template(v-if="app.sub_mode === 'mistake_mode'")
    .mistake_mode_container.has-text-centered
      | 時間切れ

  template(v-if="development_p")
    .columns
      .column
        .buttons.are-small.is-centered
          b-button(@click="app.kotae_sentaku('correct')" icon-left="checkbox-blank-circle-outline")
          b-button(@click="app.kotae_sentaku('mistake')" icon-left="close")
          b-button(@click="app.kotae_sentaku('timeout')" icon-left="timer-sand-empty")
          b-button(@click="app.g2_hayaosi_handle()") シングルトンで解答
          b-button(@click="app.g2_jikangire_handle()") シングルトンで誤答
</template>

<script>
import { support } from "./support.js"
import dayjs from "dayjs"
import the_battle_membership from "./the_battle_membership.vue"
import the_battle_question1 from "./the_battle_question1.vue"
import the_battle_question2 from "./the_battle_question2.vue"

export default {
  name: "the_battle",
  mixins: [
    support,
  ],
  components: {
    the_battle_membership,
    the_battle_question1,
    the_battle_question2,
  },
  created() {
    this.app.lobby_unsubscribe()
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_battle
  .vs_container
    justify-content: center
    align-items: center
  .deden_mode_container
    font-size: 5rem
  .mistake_mode_container
    font-size: 5rem
</style>
