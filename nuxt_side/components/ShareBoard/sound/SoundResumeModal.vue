<template lang="pug">
.SoundResumeModalInside.is-flex.is-justify-content-center.is-align-items-center.is-flex-direction-column.is-size-5.has-text-white.is-unselectable(@click="click_handle")
  p 画面をタップしてください
  p.is-size-6 よそ見すると正常に対局できなくなる恐れがあります
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
  .SoundResumeModalInside
    gap: 2rem
</style>
