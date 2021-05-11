<template lang="pug">
.ActbBattleQuestionSyVersusMembership
  .is-flex.membership_container
    figure.image.is-48x48.avatar_image
      img.is-rounded(:src="membership.user.avatar_path")
    .user_name.has-text-weight-bold.is-size-6.is_truncate.ml-3
      | {{membership.user.name}}
      br
      | {{membership.user.skill_key}}
      span.ml-1(v-if="base.config.rating_display_p")
        | {{membership.user.rating}}
      //- | {{membership.position}}
      //- | {{membership.location.name}}
    .time_format.has-text-centered.fixed_font.ml-3.has-background-white-ter
      | {{base.clock_box.single_clocks[membership.position].to_time_format}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbBattleQuestionSyVersusMembership",
  mixins: [
    support_child,
  ],
  props: {
    membership: { type: Object,  required: true, },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBattleQuestionSyVersusMembership
  .membership_container
    justify-content: center
    align-items: center
    .user_name
      max-width: 7rem
    .time_format
      font-size: $size-3
      padding: 0.25rem 1rem
      border-radius: 0.5rem
</style>
