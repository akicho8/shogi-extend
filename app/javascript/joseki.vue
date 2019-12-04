<template lang="pug">
.joseki
  .columns
    .column
      shogi_player(
        ref="main_sp"
        :run_mode="'play_mode'"
      )
</template>

<script>
export default {
  name: "joseki",
  mixins: [
  ],
  data() {
    return {
    }
  },
}
</script>

<style lang="sass">
@import "./bulma_init.scss"

.joseki
</style>
