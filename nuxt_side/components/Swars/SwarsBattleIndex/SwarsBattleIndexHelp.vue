<template lang="pug">
.SwarsBattleIndexHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'swars-search'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | よくある質問 (FAQ)
  MainSection
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          SwarsBattleIndexHelpBody
</template>

<script>
export default {
  name: "SwarsBattleIndexHelp",
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsBattleIndexHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
