<template lang="pug">
.the_result_membership_progress
  b-progress(type="is-danger" :value="record.udemae_point" size="is-medium" show-value)
    | {{record.udemae_key}}
</template>

<script>
import { support } from "./support.js"

export default {
  mixins: [
    support,
  ],
  props: {
    record: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result_membership_progress
</style>
