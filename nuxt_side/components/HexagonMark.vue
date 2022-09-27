<template lang="pug">
span.HexagonMark(:class="location_key" v-text="Location.fetch('black').name")
</template>

<script>
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "HexagonMark",
  props: {
    location_key: { type: String,  required: true },
  },
  computed: {
    Location() { return Location },
  },
}
</script>

<style lang="sass">
.HexagonMark
  // どっちもちょうどいい色
  // コントラストを強くすると変になるのでなるべく近い強さにする
  &.black
    color: $black-ter
    -webkit-text-stroke: 1px $grey-dark
  &.white
    color: $white-ter
    -webkit-text-stroke: 1px $grey-light
</style>
