<template lang="pug">
.ShareBoardHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'share-board'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | 共有将棋盤の使い方
  MainSection
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          ShareBoardHelpBody
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardHelp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
