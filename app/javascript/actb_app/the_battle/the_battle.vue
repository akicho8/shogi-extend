<template lang="pug">
.the_battle
  debug_print(v-if="app.debug_read_p" :vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode', 'app.battle.best_questions.length']" oneline)

  //////////////////////////////////////////////////////////////////////////////// ○vs○
  .vs_container.is-flex
    template(v-for="(membership, i) in app.ordered_memberships")
      the_battle_membership(:membership="membership" :key="membership.id")
      .is-1.has-text-weight-bold.is-size-4.has-text-grey-light(v-if="i === 0") vs

  //////////////////////////////////////////////////////////////////////////////// 第○問
  template(v-if="app.sub_mode === 'sm3_deden'")
    .sm3_deden_container.has-text-centered.is-size-3
      .question_index
        | 第{{app.question_index + 1}}問

  //////////////////////////////////////////////////////////////////////////////// 時間切れ
  template(v-if="app.sub_mode === 'sm6_timeout'")
    .sm6_timeout_container.has-text-centered.is-size-3
      template(v-if="app.battle.rule.key === 'marathon_rule' || app.battle.rule.key === 'hybrid_rule'")
        | 時間切れ
      template(v-if="app.battle.rule.key === 'singleton_rule'")
        template(v-if="app.otetuki_all_p")
          | 両者不正解
        template(v-else)
          | 時間切れ

  //////////////////////////////////////////////////////////////////////////////// 問題
  template(v-if="app.sub_mode === 'sm4_tactic' || app.sub_mode === 'sm5_correct'")
    question_author(:question="app.current_question" :title_display_p="false")
    the_battle_question_marathon_rule(v-if="app.battle.rule.key === 'marathon_rule' || app.battle.rule.key === 'hybrid_rule'")
    the_battle_question_singleton_rule(v-if="app.battle.rule.key === 'singleton_rule'")
    the_room_message

  //////////////////////////////////////////////////////////////////////////////// シミュレータ

  template(v-if="development_p")
    .columns
      .column
        .buttons.is-centered.are-small
          b-button(@click="app.kotae_sentaku('correct')") O
          b-button(@click="app.kotae_sentaku('timeout')") X (タイムアウト)
        .buttons.is-centered.are-small
          b-button(@click="app.wakatta_handle(false)") わかった(自分)
          b-button(@click="app.kotae_sentaku('correct')") 正解(自分)
          b-button(@click="app.x2_play_timeout_handle(false)") 駒操作中タイムアウト(自分)
        .buttons.is-centered.are-small
          b-button(@click="app.wakatta_handle(true)") わかった(相手)
          b-button(@click="app.kotae_sentaku('correct', true)") 正解(相手)
          b-button(@click="app.x2_play_timeout_handle(true)") 駒操作中タイムアウト(相手)
        .buttons.is-centered.are-small
          b-button(@click="app.battle_unsubscribe") 切断(自分)
          b-button(@click="app.member_disconnect_handle(true)") 切断(相手)
</template>

<script>
import { support } from "../support.js"
import dayjs from "dayjs"

import the_room_message                   from "../the_room_message.vue"
import the_battle_membership              from "./the_battle_membership.vue"
import the_battle_question_marathon_rule  from "./the_battle_question_marathon_rule.vue"
import the_battle_question_singleton_rule from "./the_battle_question_singleton_rule.vue"
import question_author                from "../components/question_author.vue"

export default {
  name: "the_battle",
  mixins: [
    support,
  ],
  components: {
    the_room_message,
    the_battle_membership,
    the_battle_question_marathon_rule,
    the_battle_question_singleton_rule,
    question_author,
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle
  .vs_container
    justify-content: center
    align-items: center
</style>
