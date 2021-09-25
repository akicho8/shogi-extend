<template lang="pug">
.KiwiLemonNewHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'video-new'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | 動画作成の使い方
  MainSection
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          KiwiLemonNewHelpBody
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewHelp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiLemonNewHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
