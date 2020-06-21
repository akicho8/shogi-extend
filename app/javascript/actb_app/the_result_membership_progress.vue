<template lang="pug">
.the_result_membership_progress
  //- b-progress(type="is-danger" :value="xrecord.udemae_point" size="is-medium" show-value)
  //-   | {{xrecord.udemae_key}}
  .has-text-centered.has-text-weight-bold
    | {{xrecord.udemae_key}}
  progress.progress.is-primary(:value="xrecord.udemae_point" :max="100")
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
</style>
