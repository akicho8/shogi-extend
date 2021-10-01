<template lang="pug">
.KiwiBookShowTop.columns.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
  .column.is-12-tablet.is-10-desktop.is-8-widescreen
    template(v-if="content_type.startsWith('video')")
      .image
        video.is-block(:src="base.book.lemon.browser_path" :poster="base.book.lemon.thumbnail_browser_path" controls :autoplay="true" :loop="false")
    template(v-else-if="content_type.startsWith('image')")
      .image
        img(:src="base.book.lemon.browser_path")
    template(v-else-if="content_type === 'application/zip'")
      b-icon(icon="zip-box-outline" size="is-large")
    template(v-else)
      p content_type: {{content_type}}
      p browser_path: {{base.book.lemon.browser_path}}

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
  computed: {
    content_type() { return this.base.book.lemon.content_type },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowTop
</style>
