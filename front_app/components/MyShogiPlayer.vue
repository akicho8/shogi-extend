<template lang="pug">
ShogiPlayer(
  v-bind="{...default_params, ...$attrs}"
  v-on="$listeners"
  ref="pure_sp"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"

export default {
  inheritAttrs: false,
  components: {
    ShogiPlayer,
  },
  computed: {
    default_params() {
      return {
        sound_effect: true,
        volume: 0.5,
      }
    }
  },
}
</script>
