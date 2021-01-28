<template lang="pug">
client-only
  WkbkBookIndexApp
</template>

<script>
export default {
  name: "wkbk",
  computed: {
    meta() {
      return {
        title: "みんなで作る問題集",
        description: "",
        og_image_key: "wkbk_books",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
