<template lang="pug">
.the_result
  .columns.is-mobile.result_container
    .column
      .has-text-centered.is-size-3.has-text-weight-bold
        template(v-if="$parent.current_membership.judge_key === 'win'")
          .has-text-danger
            | YOU WIN !
        template(v-if="$parent.current_membership.judge_key === 'lose'")
          .has-text-success
            | YOU LOSE !
  .columns.is-mobile.result_container
    template(v-for="(membership, i) in $parent.room.memberships")
      .column.user_container.is-flex
        template(v-if="membership.rensho_count >= 2")
          .icon_up_message.has-text-weight-bold
            | {{membership.rensho_count}}連勝中！
        template(v-if="membership.judge_key === 'lose' && $parent.room.final_info.lose_side")
          .icon_up_message.has-text-danger.has-text-weight-bold
            | {{$parent.room.final_info.name}}
        figure.image.is-64x64
          img.is-rounded(:src="membership.user.avatar_path")
        .user_name.has-text-weight-bold
          | {{membership.user.name}}
        .user_quest_index.has-text-weight-bold.is-size-4
          | {{membership.quest_index}}
        .user_rating.has-text-weight-bold
          | {{membership.user.actf_profile.rating}}
          span.user_rating_diff
            template(v-if="membership.user.actf_profile.rating_last_diff >= 0")
              span.has-text-primary
                | (+{{membership.user.actf_profile.rating_last_diff}})
            template(v-if="membership.user.actf_profile.rating_last_diff < 0")
              span.has-text-danger
                | ({{membership.user.actf_profile.rating_last_diff}})
      template(v-if="i === 0")
        .column.is-1.vs_mark.is-flex.has-text-weight-bold.is-size-4
          | vs

  .columns.is-mobile
    .column
      .buttons.is-centered
        b-button.has-text-weight-bold(@click="$parent.lobby_button_handle" type="is-primary")
          | ロビーに戻る
</template>

<script>
import the_support from './the_support'

export default {
  mixins: [
    the_support,
  ],
  components: {
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
    }
  },

  created() {
  },

  watch: {
  },

  methods: {
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_result
  .result_container
    .vs_mark
      flex-direction: column
      justify-content: center
      align-items: center
</style>
