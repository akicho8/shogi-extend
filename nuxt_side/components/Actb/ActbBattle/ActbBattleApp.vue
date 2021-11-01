<template lang="pug">
.ActbBattleApp
  DebugPrint(v-if="base.debug_read_p" :vars="['base.sub_mode', 'base.member_infos_hash', 'base.question_index', 'base.x_mode', 'base.battle.best_questions.length']" oneline)

  PageCloseButton(@click="base.rensyu_yameru_handle" v-if="base.room.bot_user_id")
  ActbRoomEmotion(:base="base")

  template(v-if="base.current_strategy_key === 'sy_versus'")
    ActbBattleQuestionSyVersus(:base="base")

  //////////////////////////////////////////////////////////////////////////////// ○vs○
  template(v-if="base.current_strategy_key === 'sy_marathon' || base.current_strategy_key === 'sy_singleton' || base.current_strategy_key === 'sy_hybrid'")
    .vs_container.is-flex
      template(v-for="(membership, i) in base.ordered_memberships")
        ActbBattleMembership(:base="base" :membership="membership" :key="membership.id")
        .is-1.has-text-weight-bold.is-size-4.has-text-grey-light.mx-1(v-if="i === 0") vs
    //////////////////////////////////////////////////////////////////////////////// 第○問
    template(v-if="base.sub_mode === 'sm3_deden'")
      .sm3_deden_container.has-text-centered.is-size-3
        .question_index
          | 第{{base.question_index + 1}}問

    //////////////////////////////////////////////////////////////////////////////// 時間切れ
    template(v-if="base.sub_mode === 'sm6_timeout'")
      .sm6_timeout_container.has-text-centered.is-size-3
        template(v-if="base.current_strategy_key === 'sy_marathon' || base.current_strategy_key === 'sy_hybrid'")
          | 時間切れ
        template(v-if="base.current_strategy_key === 'sy_singleton'")
          template(v-if="base.otetuki_all_p")
            | 両者不正解
          template(v-else)
            | 時間切れ

    //////////////////////////////////////////////////////////////////////////////// 問題
    template(v-if="base.sub_mode === 'sm4_tactic' || base.sub_mode === 'sm5_correct'")
      ActbQuestionAuthor(:question="base.current_question" :title_display_p="false")
      ActbBattleQuestionSyMarathon(:base="base" v-if="base.current_strategy_key === 'sy_marathon' || base.current_strategy_key === 'sy_hybrid'")
      ActbBattleQuestionSySingleton(:base="base" v-if="base.current_strategy_key === 'sy_singleton'")
      ActbRoomMessage(:base="base")

  //////////////////////////////////////////////////////////////////////////////// シミュレータ

  template(v-if="development_p")
    .columns
      .column
        .buttons.is-centered.are-small
          b-button(@click="base.kotae_sentaku('correct')") O
          b-button(@click="base.kotae_sentaku('timeout')") X (タイムアウト)
        .buttons.is-centered.are-small
          b-button(@click="base.answer_button_push_handle(false)") わかった(自分)
          b-button(@click="base.kotae_sentaku('correct')") 正解(自分)
          b-button(@click="base.x2_play_timeout_handle(false)") 駒操作中タイムアウト(自分)
        .buttons.is-centered.are-small
          b-button(@click="base.answer_button_push_handle(true)") わかった(相手)
          b-button(@click="base.kotae_sentaku('correct', true)") 正解(相手)
          b-button(@click="base.x2_play_timeout_handle(true)") 駒操作中タイムアウト(相手)
        .buttons.is-centered.are-small
          b-button(@click="base.battle_unsubscribe") 切断(自分)
          b-button(@click="base.member_disconnect_handle(true)") 切断(相手)
        .buttons.is-centered.are-small
          b-button(@click="base.new_challenge_accept_handle") マッチングの人と対戦する
          b-button(@click="base.new_challenge_accept_handle") 挑戦者発見
</template>

<script>
import { support_child } from "../support_child.js"
import { scroll_auto_disable } from "../../models/scroll_auto_disable.js"
import dayjs from "dayjs"

export default {
  name: "ActbBattleApp",
  mixins: [
    support_child,
    scroll_auto_disable,
  ],

}
</script>

<style lang="sass">
@import "../support.sass"

// PCではスクロールしても問題ないので入れない
// html
//   &.production
//     overflow: hidden

.ActbBattleApp
  .vs_container
    justify-content: center
    align-items: center
</style>
