<template lang="pug">
XclockApp
</template>

<script>
export default {
  name: "Xclock",
  computed: {
    meta() {
      return {
        title: "対局時計",
        description: "ネット対局と同じような持ち時間のプリセットが入った対局時計です。大会などで対局時計が足りないときにどうぞ",
        og_image_key: "vs-clock",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
