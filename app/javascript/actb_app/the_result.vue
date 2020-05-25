<template lang="pug">
.the_result
  .columns.is-mobile.win_lose_container
    .column
      .has-text-centered.is-size-3.has-text-weight-bold
        template(v-if="app.current_membership.judge_key === 'win'")
          .has-text-danger
            | YOU WIN !
        template(v-if="app.current_membership.judge_key === 'lose'")
          .has-text-success
            | YOU LOSE !
  .columns.is-mobile.result_container
    template(v-for="(membership, i) in app.battle.memberships")
      .column.user_container.is-flex
        .icon_up_message.has-text-weight-bold
          template(v-if="membership.rensho_count >= 1")
            | {{membership.rensho_count}}連勝中！
          template(v-if="membership.rensho_count >= 1")
            | {{membership.renpai_count}}連敗中！
          template(v-if="membership.rensho_count === 0 && membership.renpai_count === 0")
            | &nbsp;

        template(v-if="membership.judge_key === 'lose' && app.battle.final_info.lose_side")
          .icon_up_message.has-text-danger.has-text-weight-bold
            | {{app.battle.final_info.name}}
        figure.image.is-64x64
          img.is-rounded(:src="membership.user.avatar_path")
        .user_name.has-text-weight-bold
          | {{membership.user.name}}
        .user_quest_index.has-text-weight-bold.is-size-4
          | {{membership.question_index}}
        .user_rating.has-text-weight-bold
          | {{membership.user.actb_newest_profile.rating}}
          span.user_rating_diff
            template(v-if="membership.user.actb_newest_profile.rating_last_diff >= 0")
              span.has-text-primary
                | (+{{membership.user.actb_newest_profile.rating_last_diff}})
            template(v-if="membership.user.actb_newest_profile.rating_last_diff < 0")
              span.has-text-danger
                | ({{membership.user.actb_newest_profile.rating_last_diff}})
        .battle_continue_container.has-text-weight-bold
          template(v-if="app.battle_continue_tap_counts[membership.id]")
            | 再戦希望
          template(v-else)
            | &nbsp;
      template(v-if="i === 0")
        .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
          | vs

  .columns.is-mobile.footer_container
    .column
      .buttons.is-centered
        b-button.has-text-weight-bold(@click="app.battle_continue_handle" :type="app.battle_continue_tap_counts[app.current_membership.id] ? 'is-primary' : ''")
          | つづける
        b-button.has-text-weight-bold(@click="app.yameru_handle")
          | やめる

  .columns.is-mobile(v-if="development_p")
    .column
      .buttons.is-centered.are-small
        b-button(@click="app.battle_continue_force_handle") 強制的に続行

  debug_print(:vars="['app.battle_continue_tap_counts', 'app.battle_count', 'app.battle.rensen_index', 'app.score_debug_info', 'app.score_max']" v-if="development_p")
</template>

<script>
import { support } from "./support.js"

export default {
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_result
  margin-top: 4.5rem
  .win_lose_container
  .result_container
    .vs_mark
      flex-direction: column
      justify-content: center
      align-items: center
    .battle_continue_container

  .footer_container
    .buttons
      flex-direction: column
      .button
        min-width: 12rem
        &:not(:first-child)
          margin-top: 1.5rem
</style>
