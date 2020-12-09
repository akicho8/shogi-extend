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
  computed: {
    meta() {
      return {
        title: "サービス利用規約",
      }
    },
  },
}
</script>
