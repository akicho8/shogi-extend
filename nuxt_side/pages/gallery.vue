<template lang="pug">
.GalleryWood
  MainNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold.px_0_if_mobile(@click.native="title_click_handle")
        | 木目盤テクスチャ集
    template(slot="end")
      b-navbar-item.slider_container.is-hidden-mobile(tag="div")
        b-slider(:min="0" :max="3" :tooltip="false" rounded v-model="column_size_code" type="is-light" size="is-small" @input="slider_change_handle")
          b-slider-tick(:value="0")
          b-slider-tick(:value="1")
          b-slider-tick(:value="2")
          b-slider-tick(:value="3")
  MainSection.when_mobile_footer_scroll_problem_workaround
    .container.is-fluid
      .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
        .column.is-12
          //- https://buefy.org/documentation/pagination
          b-pagination(:total="total" :per-page="per" :current.sync="page" @change="page_change_handle" order="default" simple)
        template(v-for="(_, i) in page_items")
          .column.is_texture(:class="column_class")
            a.image.is-block(:href="filename_for(i)" target="_blank" @click="sound_play('click')")
              img(:src="filename_for(i)")
              .image_number
                .image_number_body
                  | {{display_number_for(i)}}
        .column.is-12.cc_container.is-flex.is-justify-content-center
          a.image.is-block(href="https://creativecommons.org/licenses/by-sa/4.0/deed.ja" target="_blank" @click="sound_play('click')")
            img(src="by-sa.svg")
</template>

<script>
const ModExtsprintf = require('extsprintf')
import { simple_patination_methods } from "@/components/simple_patination_methods.js"

export default {
  name: "GalleryWood",
  mixins: [simple_patination_methods],
  data() {
    return {
      column_size_code: 1,
    }
  },

  created() {
    this.total = 192
  },
  methods: {
    display_number_for(i) {
      return this.offset + i + 1
    },
    filename_for(i) {
      return ModExtsprintf.sprintf("/material/board/%04d.png", this.offset + i + 1)
    },
    title_click_handle() {
      this.sound_play("click")
      this.page = 1
    },
    slider_change_handle(v) {
      this.sound_play("click")
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
    column_class() {
      if (this.column_size_code === 0) {
        return ["is-4-tablet", "is-3-desktop", "is-2-widescreen", "is-1-fullhd"]
      }
      if (this.column_size_code === 1) {
        return ["is-6-tablet", "is-4-desktop", "is-3-widescreen", "is-2-fullhd"]
      }
      if (this.column_size_code === 2) {
        return ["is-12-tablet", "is-6-desktop", "is-4-widescreen", "is-3-fullhd"]
      }
      if (this.column_size_code === 3) {
        return ["is-12-tablet", "is-12-desktop", "is-6-widescreen", "is-4-fullhd"]
      }
    },
  },
}
</script>

<style lang="sass">
.GalleryWood
  .slider_container
    width: 10rem

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

  .is_texture
    img
      border-radius: 3px

  .image_number
    position: absolute
    top: 0
    left: 0
    .image_number_body
      line-height: 1.0
      padding: 0.25rem 0.25rem
      font-size: $size-7
      border-radius: 3px
      color: change_color($warning, $lightness: 30%)
      background-color: change_color($warning, $lightness: 100%)
      opacity: 0.1

  .cc_container
    .image
      width: 100%
      +tablet
        max-width: 12rem

.STAGE-development
  .GalleryWood
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)
    .image
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .img
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .image_number
      border: 1px dashed change_color($warning, $alpha: 0.5)
</style>
