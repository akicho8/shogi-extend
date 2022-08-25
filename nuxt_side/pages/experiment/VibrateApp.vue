<template lang="pug">
.VibrateApp
  .buttons
    b-button(@click="vibrate1_handle") vibrate1_vibrate
    b-button(@click="vibrate2_handle") vibrate2_vibrate
  .buttons
    b-button(@click="vibrate_short") vibrate_short
    b-button(@click="vibrate_middle") vibrate_middle
    b-button(@click="vibrate_long") vibrate_long
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
      // this.vibrate([50, 200, 100, 50, 50, 50, 50, 200, 100, 50, 50])
      const tette = [50, 200, 100, 50]
      // this.vibrate([...tette, ...tette, ...tette, ...tette])
      this.vibrate([...tette, ...tette, 50])
    },
    vibrate2_handle() {
      // const on  = 75
      // const off = 75
      // this.vibrate([50, 200, 100, 50, 50, 50, 50, 200, 100, 50, 50])
      const tette = [100, 50, 100, 50]
      this.vibrate([...tette, ...tette, ...tette, ...tette])
    },
  },
}
</script>

<style lang="sass">
.VibrateApp
</style>
