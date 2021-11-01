<template lang="pug">
client-only
  .particle_test
    .buttons
      template(v-for="row in EffectInfo.values")
        b-button(@click="run_handle(row.key)") {{row.key}}
    .galaxy
      .gunship
</template>

<script>
import { EffectInfo } from "shogi-player/components/models/effect_info.js"

export default {
  name: "particle_test",
  data() {
    return {
    }
  },
  methods: {
    run_handle(key) {
      EffectInfo.fetch(key).run({from_selector: ".gunship"})
    },
  },
  computed: {
    EffectInfo() { return EffectInfo },
  },
}
</script>

<style lang="sass">
.galaxy
  margin: auto
  position: relative
  width: 640px
  height: 480px
  border: 1px solid blue
  display: flex
  align-items: center
  justify-content: center
  .gunship
    width: 100px
    height: 100px
    background-color: red
</style>
