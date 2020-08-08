<template lang="pug">
.the_result_membership_progress.mt-1
  //- b-progress(type="is-danger" :value="xrecord.skill_point" size="is-medium" show-value)
  //-   | {{xrecord.skill_key}}
  .has-text-centered.has-text-weight-bold
    | {{xrecord.skill_key}}
  progress.progress.is-primary(:value="xrecord.skill_point" :max="100")
</template>

<script>
import { support } from "./support.js"

export default {
  mixins: [
    support,
  ],
  props: {
    xrecord: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result_membership_progress
  width: 8rem
</style>
