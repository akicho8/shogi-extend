<template lang="pug">
.the_matching.columns.is-paddingless
  .column
    .has-text-centered.has-text-weight-bold
      .wait_notification
        | 対戦相手を待機中
      p {{interval_timer_count}}
      p ±{{matching_rate_threshold}}
    b-progress(type="is-primary")
    .buttons.is-centered
      button.delete.is-large(@click="cancel_handle")
</template>

<script>
import support from "./support.js"
import the_matching_interval from './the_matching_interval.js'

export default {
  name: "the_matching",
  mixins: [
    support,
    the_matching_interval,
  ],
  props: {
    info: { required: true },
  },
  data() {
    return {
    }
  },

  created() {
    this.matching_init()
    // this.$lobby.perform("matching_start")
    this.main_nav_set(false)
  },

  beforeDestroy() {
    this.interval_timer_clear()
  },

  watch: {
  },

  methods: {
    cancel_handle() {
      this.interval_timer_clear()
      this.$parent.cancel_handle()
    },
  },

  computed: {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_matching
  .wait_notification
    padding: 1rem 0
</style>
