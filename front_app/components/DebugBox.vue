<template lang="pug">
.DebugBox(v-if="development_p && show_p" @click="click_handle")
  slot
</template>

<script>
export default {
name: "DebugBox",
  data() {
    return {
      show_p: true,
    }
  },
  methods: {
    click_handle() {
      this.show_p = !this.show_p
    },
  },
}
</script>

<style lang="sass">
.DebugBox
  color: $white
  position: fixed
  top: 0
  left: 0
  background-color: hsla(0, 0%, 0%, 0.6)
  padding: 1rem
  z-index: 100
</style>
