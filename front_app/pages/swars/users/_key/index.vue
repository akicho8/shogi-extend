<template lang="pug">
client-only
  .swars-users-key
    SwarsUserShowApp
</template>

<script>
export default {
  name: "swars-users-key",
  computed: {
    meta() {
      return {
        title: [this.$route.params.key, "将棋ウォーズプレイヤー情報"],
        og_image_key: "swars-users-key",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-users-key
</style>
