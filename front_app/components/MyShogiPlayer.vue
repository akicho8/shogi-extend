<template lang="pug">
  ShogiPlayer(v-bind="$attrs" v-on="$listeners")
</template>

<script>

import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"

export default {
  components: {
    ShogiPlayer,
  }
}
</script>

<style lang="sass">
</style>
