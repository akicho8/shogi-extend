<template lang="pug">
.about-terms
  .content
    .title.is-4.has-text-centered-mobile サービス利用規約
    hr
    p
      | 重いからって連打しちゃだめ
</template>

<script>
export default {
  name: "about-terms",
  layout: "about",
  mounted() {
    this.talk_stop()
    this.talk("重いからって連打しちゃだめ (そんだけ)")
  },
}
</script>

<style lang="sass">
.about-terms
</style>
