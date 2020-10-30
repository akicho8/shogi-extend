<template lang="pug">
.about-privacy-policy
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold プライバシーポリシー

  MainSection
    .container
      p
        | 個人情報保護法を遵守すると共に適切な取扱い及び保護に努めます
</template>

<script>
export default {
  name: "about-privacy-policy",
  mounted() {
    // this.talk_stop()
    // this.talk("個人情報保護法を遵守すると共に適切な取扱い及び保護に努めます")
  },
}
</script>

<style lang="sass">
.about-privacy-policy
</style>
