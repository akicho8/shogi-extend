<template lang="pug">
.about-terms
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold サービス利用規約

  MainSection
    .container
      p
        | 重いからって連打しちゃだめ
</template>

<script>
export default {
  name: "about-terms",
  mounted() {
    // this.talk_stop()
    // this.talk("重いからって連打しちゃだめ (そんだけ)")
  },
}
</script>

<style lang="sass">
.about-terms
</style>
