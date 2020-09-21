<template lang="pug">
ShogiPlayer(
  v-bind="$attrs"
  v-on="$listeners"
  :sound_effect="true"
  :volume="0.5"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"

export default {
  components: {
    ShogiPlayer,
  }
}
</script>
