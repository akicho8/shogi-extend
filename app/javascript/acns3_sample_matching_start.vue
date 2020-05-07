<template lang="pug">
.acns3_sample_matching_start.columns.is-paddingless
  .column
    .has-text-centered.has-text-weight-bold
      p 対戦相手を待機中
      p {{interval_timer_count}}
      p ±{{matching_rate_threshold}}
    b-progress(type="is-primary")
    .buttons.is-centered
      button.delete.is-large(@click="cancel_handle")
</template>

<script>
import acns3_sample_support from './acns3_sample_support.js'
import acns3_sample_matching_start_interval from './acns3_sample_matching_start_interval.js'

export default {
  name: "acns3_sample_matching_start",
  mixins: [
    acns3_sample_support,
    acns3_sample_matching_start_interval,
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
@import "./stylesheets/bulma_init.scss"
.acns3_sample_matching_start
</style>
