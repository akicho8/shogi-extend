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
  top: 0.5rem
  left: 0.5rem
  background-color: hsla(0, 0%, 0%, 0.7)
  padding: 1rem
  z-index: 100
  max-width: 25vw
  overflow: auto
  white-space: nowrap
  border-radius: 0.5rem
</style>
