<template lang="pug">
client-only
  .click_event_test_for_ios15
    .buttons
      b-button(@pointerdown="click_handle") pointerdown
      b-button(@pointerdown.passive="click_handle") pointerdown.passive
      b-button(@pointerdown.capture="click_handle") pointerdown.capture
      b-button(@mousedown="click_handle") mousedown
      b-button(@touchstart="click_handle") touchstart
      b-button(@click="click_handle") click
      b-button(@dblclick="click_handle") dblclick
      b-button(@pointerdown="click_handle" @mousedown="click_handle" @touchstart="click_handle" @click="click_handle" @dblclick="click_handle") all
    .box
      | {{counter}}
    .box
      | {{list}}
</template>

<script>
import _ from "lodash"

export default {
  name: "click_event_test_for_ios15",
  data() {
    return {
      counter: 0,
      list: [],
    }
  },
  methods: {
    click_handle(e) {
      // e.preventDefault()
      // e.stopPropagation()
      console.log(e)
      this.sfx_click()
      this.counter += 1
      this.list = [e.type, ...this.list]
      this.list = _.take(this.list, 10)
    },
  },
}
</script>

<style lang="sass">
</style>
