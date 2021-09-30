<template lang="pug">
.KiwiBookShowTop.columns.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
  .column.is-12-tablet.is-10-desktop.is-8-widescreen
    figure.image
      video.is-block(:src="base.book.lemon.browser_path" :poster="base.book.lemon.thumbnail_browser_path" controls :autoplay="true" :loop="false")
    KiwiBookInfo.mt-4(:base="base" :book="base.book")
  .column
     KiwiBookShowMessage(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowTop",
  mixins: [support_child],
  mounted() {
    this.__assert__(this.present_p(this.base.book), "this.present_p(this.base.book)")
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowTop
</style>
