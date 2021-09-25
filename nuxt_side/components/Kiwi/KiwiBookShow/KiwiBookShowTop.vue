<template lang="pug">
.KiwiBookShowTop.columns.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
  .column.is-12-tablet.is-10-desktop.is-8-widescreen
    //- .column.is-narrow
    figure.image
      video.is-block(:src="base.book.lemon.browser_path" controls :autoplay="true" :loop="false")
    .mt-4
      KiwiBookInfo(:base="base" :book="base.book")
  .column
    .box
      | コメント1
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowTop",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowTop
</style>
