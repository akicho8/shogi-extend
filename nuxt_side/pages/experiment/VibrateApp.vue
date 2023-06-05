<template lang="pug">
.VibrateApp
  .buttons
    b-button(@click="vibrate1_handle") vibrate1_vibrate
    b-button(@click="vibrate2_handle") vibrate2_vibrate
  .buttons
    b-button(@click="$beat.call_short") $beat.call_short
    b-button(@click="$beat.call_middle") $beat.call_middle
    b-button(@click="$beat.call_long") $beat.call_long
</template>

<script>
export default {
  name: "VibrateApp",
  data() {
    return {
    }
  },
  methods: {
    vibrate1_handle() {
      // const on  = 75
      // const off = 75
      // this.$beat.call_custom([50, 200, 100, 50, 50, 50, 50, 200, 100, 50, 50])
      const tette = [50, 200, 100, 50]
      // this.$beat.call_custom([...tette, ...tette, ...tette, ...tette])
      this.$beat.call_custom([...tette, ...tette, 50])
    },
    vibrate2_handle() {
      // const on  = 75
      // const off = 75
      // this.$beat.call_custom([50, 200, 100, 50, 50, 50, 50, 200, 100, 50, 50])
      const tette = [100, 50, 100, 50]
      this.$beat.call_custom([...tette, ...tette, ...tette, ...tette])
    },
  },
}
</script>

<style lang="sass">
.VibrateApp
  __css_keep__: 0
</style>
