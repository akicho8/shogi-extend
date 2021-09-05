<template lang="pug">
client-only
  .stopwatch
    StopwatchApp
</template>

<script>
export default {
  name: "stopwatch",
  computed: {
    meta() {
      return {
        title: "詰将棋用ストップウォッチ",
        description: "詰将棋を繰り返し解くのに特化したストップウォッチです",
        og_image_key: "stopwatch",
      }
    },
  },
}
</script>

<style lang="sass">
.stopwatch
</style>
