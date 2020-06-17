<template lang="pug">
.the_result_membership_progress
  //- div moto_udemae={{moto_udemae}}
  //- div moto_point={{moto_point}}
  //- b-progress(:value="progress_value" show-value)
  //-   | {{udemae_key}}
  b-progress(type="is-danger" :value="record.udemae_point" size="is-medium" show-value)
    | {{record.udemae_key}}
  //- div
  //-   debug_print
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
  data() {
    return {
      // progress_interval_count: null,
      // progress_interval_id: null,
      // progress_value: null,
      // mode: null,
      // mode_count: null,
      // udemae_key: null,
      // total_counter: null,
    }
  },
  mounted() {
    // this.progress_interval_start()
  },
  beforeDestroy() {
    // this.progress_interval_clear()
  },
  methods: {
    // progress_interval_start() {
    //   this.progress_interval_clear()
    //   this.progress_interval_count = 0
    //   this.progress_interval_id = setInterval(this.progress_interval_processing, 1000 / 10)
    //
    //   this.mode = "start"
    //   this.mode_count = 0
    // },
    // progress_interval_clear() {
    //   if (this.progress_interval_id) {
    //     clearInterval(this.progress_interval_id)
    //     this.progress_interval_id = null
    //   }
    // },
    // progress_interval_processing() {
    //   if (this.mode === "start") {
    //     if (this.mode_count === 0) {
    //       this.udemae_key = this.moto_udemae.key
    //       this.total_counter = 0
    //
    //       this.mode = "move"
    //       this.mode_count = 0
    //     }
    //   }
    //   if (this.mode === "move") {
    //     if (this.mode_count === 0) {
    //     }
    //     this.total_counter += this.sign
    //     if (this.total_counter >= this.record.udemae_last_diff) {
    //       this.mode = "done"
    //       this.mode_count = 0
    //       return
    //     }
    //     if (this.total_counter <= this.record.udemae_last_diff) {
    //       this.mode = "done"
    //       this.mode_count = 0
    //       return
    //     }
    //     this.progress_value = this.record.udemae_point + this.total_counter
    //
    //     const rdiff = Math.floor(this.progress_value / 100)
    //     const rest = this.progress_value % 100
    //
    //     if (rdiff != 0) {
    //       const udemae_info = this.app.UdemaeInfo.fetch(this.record.udemae_key)
    //       const next_udemae = this.app.UdemaeInfo.lookup(udemae_info.code + rdiff)
    //       this.udemae_key = next_udemae.key
    //       this.progress_value = rest
    //     }
    //   }
    //
    //   this.mode_count += 1
    // },
  },
  computed: {
    // sign() {
    //   if (this.record.udemae_last_diff > 0) {
    //     return 1
    //   } else {
    //     return -1
    //   }
    // },
    // moto_udemae() {
    //   const ima_udemae = this.app.UdemaeInfo.fetch(this.record.udemae_key)
    //
    //   const v = this.moto_point
    //   const rdiff = Math.floor(v / 100)
    //   const rest = v % 100
    //
    //   const next_udemae = this.app.UdemaeInfo.lookup(ima_udemae.code + rdiff)
    //   if (next_udemae) {
    //     return next_udemae
    //   } else {
    //     return this.app.UdemaeInfo.fetch(this.record.udemae_key)
    //   }
    // },
    // moto_point() {
    //   return this.record.udemae_point
    //     // - this.record.udemae_last_diff
    // },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result_membership_progress
</style>
