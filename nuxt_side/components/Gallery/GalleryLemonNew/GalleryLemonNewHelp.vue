<template lang="pug">
.GalleryLemonNewHelp
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'video-new'}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | 動画作成の使い方
  MainSection.when_mobile_footer_scroll_problem_workaround
    .container
      .columns.is-centered.is-gapless
        .MainColumn.column
          GalleryLemonNewHelpBody
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryLemonNewHelp",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./all_support.sass"
.GalleryLemonNewHelp
  .MainSection.section
    +mobile
      padding: 0rem
    +tablet
      padding: 0rem
</style>
