<template lang="pug">
.XmovieHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'movie-factory'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | 動画生成の使い方
  MainSection
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          XmovieHelpBody
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieHelp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XmovieHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
