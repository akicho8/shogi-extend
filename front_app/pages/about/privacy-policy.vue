<template lang="pug">
.privacy-policy
  h1 プライバシーポリシー
  .has-background-primary PRIMARY
  .has-background-twitter TWITTER
  .has-background-orange ORANGE
  .hamburger
  .foo あいうえお
  .foo ABC
  .content
    p
      | 個人情報保護法を遵守すると共に適切な取扱い及び保護に努めます。
</template>

<script>
export default {
  name: 'privacy-policy',
  layout: "about",
}
</script>

<style lang="sass">
.privacy-policy
  .content
    +mobile
      background-color: $orange
    // p
    //   background-color: $foo
    //   +mobile
    //     background-color: $orange
</style>

