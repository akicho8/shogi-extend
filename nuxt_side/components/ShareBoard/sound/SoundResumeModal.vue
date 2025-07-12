<template lang="pug">
.SoundResumeModalInside.is-flex.is-justify-content-center.is-align-items-center.is-flex-direction-column(@click="click_handle")
  .is-size-5.has-text-white.is-unselectable
    | 画面をタップしてください
</template>

<script>
import { support_child   } from "../support_child.js"

export default {
  name: "SoundResumeModal",
  mixins: [support_child],
  methods: {
    click_handle() {
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SoundResumeModal
  .modal-background
    background-color: hsla(0, 0%, 0%, 0.75)
</style>
