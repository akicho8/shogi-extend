<template lang="pug">
.columns
  .column
    ShogiPlayer
</template>

<script>
import ShogiPlayer from "shogi-player/components/ShogiPlayer.vue"

export default {
  components: {
    ShogiPlayer,
  },
}
</script>

<style lang="sass">
$sp_assets_dir: "../node_modules/shogi-player/assets"
@import "../node_modules/shogi-player/components/ShogiPlayer.sass"
</style>
