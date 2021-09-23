<template lang="pug">
.XmovieNewHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'movie-factory'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | 動画生成の使い方
  MainSection
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          XmovieNewHelpBody
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieNewHelp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XmovieNewHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
