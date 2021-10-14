<template lang="pug">
.GalleryWood
  MainNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold.px_0_if_mobile(@click.native="title_click")
        | 木目盤テクスチャ集
  MainSection.when_mobile_footer_scroll_problem_workaround
    .container.is-fluid
      .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
        template(v-for="(_, i) in page_items")
          .column.is-6-tablet.is-4-desktop.is-3-widescreen
            a.image.is-block(:href="filename_for(i)" target="_blank" @click="sound_play('click')")
              img(:src="filename_for(i)")
        .column.is-12
          .level
            .level-left
              .level-item
            .level-right
              .level-item
                b-pagination(
                  :total="total"
                  :per-page="per"
                  :current.sync="page"
                  @change="page_change_handle"
                  order="is-right"
                  simple
                  )
        .column.is-12.cc_container
          a.image.is-block(href="https://creativecommons.org/licenses/by-sa/4.0/deed.ja" target="_blank" @click="sound_play('click')")
            img(src="by-sa.svg")
</template>

<script>
const ModExtsprintf = require('extsprintf')
import { simple_patination_methods } from "../../components/simple_patination_methods.js"

export default {
  name: "GalleryWood",
  mixins: [simple_patination_methods],
  created() {
    this.total = 192
  },
  methods: {
    filename_for(i) {
      return ModExtsprintf.sprintf("/x-texture/wood/%04d.png", this.offset + i + 1)
    },
    title_click() {
      this.sound_play("click")
      this.page = 1
    },
  },
  computed: {
    meta() {
      return {
        title: "木目盤テクスチャ集",
        description: "将棋盤用に特化した木目盤のテクスチャ集です",
        og_image_key: "gallery_wood",
      }
    },
    default_per() { return 100 },
  },
}
</script>

<style lang="sass">
.GalleryWood
  .MainSection.section
    +mobile
      padding: 0.75rem
      .columns
        margin: 0
      .column
        padding: 0
        &:not(:first-child)
          margin-top: 0.75rem
    +tablet
      padding: 1.5rem
  .cc_container
    display: flex
    justify-content: center
    align-items: center
    .image
      max-width: 8rem
</style>
