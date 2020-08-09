<template lang="pug">
.the_battle
  debug_print(v-if="app.debug_read_p" :vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode', 'app.battle.best_questions.length']" oneline)

  a.delete.page_delete.is-large.is_top_left_fixed(@click="app.rensyu_yameru_handle" v-if="app.room.bot_user_id")
  the_room_emotion

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
      template(v-if="app.current_strategy_key === 'sy_marathon' || app.current_strategy_key === 'sy_hybrid'")
        | 時間切れ
      template(v-if="app.current_strategy_key === 'sy_singleton'")
        template(v-if="app.otetuki_all_p")
          | 両者不正解
        template(v-else)
          | 時間切れ

  //////////////////////////////////////////////////////////////////////////////// 問題
  template(v-if="app.sub_mode === 'sm4_tactic' || app.sub_mode === 'sm5_correct'")
    question_author(:question="app.current_question" :title_display_p="false")
    the_battle_question_sy_marathon(v-if="app.current_strategy_key === 'sy_marathon' || app.current_strategy_key === 'sy_hybrid'")
    the_battle_question_sy_singleton(v-if="app.current_strategy_key === 'sy_singleton'")
    the_room_message

  //////////////////////////////////////////////////////////////////////////////// シミュレータ

  template(v-if="development_p")
    .columns
      .column
        .buttons.is-centered.are-small
          b-button(@click="app.kotae_sentaku('correct')") O
          b-button(@click="app.kotae_sentaku('timeout')") X (タイムアウト)
        .buttons.is-centered.are-small
          b-button(@click="app.answer_button_push_handle(false)") わかった(自分)
          b-button(@click="app.kotae_sentaku('correct')") 正解(自分)
          b-button(@click="app.x2_play_timeout_handle(false)") 駒操作中タイムアウト(自分)
        .buttons.is-centered.are-small
          b-button(@click="app.answer_button_push_handle(true)") わかった(相手)
          b-button(@click="app.kotae_sentaku('correct', true)") 正解(相手)
          b-button(@click="app.x2_play_timeout_handle(true)") 駒操作中タイムアウト(相手)
        .buttons.is-centered.are-small
          b-button(@click="app.battle_unsubscribe") 切断(自分)
          b-button(@click="app.member_disconnect_handle(true)") 切断(相手)
        .buttons.is-centered.are-small
          b-button(@click="app.battle_request_accept_handle") マッチングの人と対戦する
          b-button(@click="app.battle_request_accept_handle") 挑戦者発見
</template>

<script>
import { support } from "../support.js"
import dayjs from "dayjs"

import the_room_message                   from "../the_room_message.vue"
import the_room_emotion                   from "../the_room_emotion.vue"
import the_battle_membership              from "./the_battle_membership.vue"
import the_battle_question_sy_marathon  from "./the_battle_question_sy_marathon.vue"
import the_battle_question_sy_singleton from "./the_battle_question_sy_singleton.vue"
import question_author                from "../components/question_author.vue"

export default {
  name: "the_battle",
  mixins: [
    support,
  ],
  components: {
    the_room_emotion,
    the_room_message,
    the_battle_membership,
    the_battle_question_sy_marathon,
    the_battle_question_sy_singleton,
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
  .page_delete
    z-index: 1          // mobile だと flex の領域に負けて押せない対策
</style>
