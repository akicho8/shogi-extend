<template lang="pug">
SbDashboard
</template>

<script>
export default {
  name: "share-board-dashboard",
  computed: {
    meta() {
      return {
        title: ["対局履歴", "共有将棋盤"],
        description: "",
        og_image_key: "share-board",
      }
    }
  },
}
</script>

<style lang="sass">
</style>
