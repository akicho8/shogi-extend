<template lang="pug">
.AdapterFormat
  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") 対応形式確認

  MainSection
    .container.is-fluid
      template(v-for="(e, i) in TryFormatInfo.values")
        .title.is-5 {{e.name}}
        .columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-2-widescreen.is-2-fullhd
          template(v-for="e in e.items")
            .column.is-4-tablet.is-3-desktop.is-2-widescreen
              .is-size-7
                b-tag.mr-1(type="is-danger" v-if="!e.success" rounded size="is-small") 反則
                | {{e.name}}
              pre.source_pre.box.is-shadowless.mt-1.mb-0.has-background-white-ter.is-family-monospace
                | {{$gs.str_strip(e.body)}}
              b-button.mt-1(
                expanded
                tag="nuxt-link"
                :to="{name: 'adapter', query: {body: $gs.str_strip(e.body)}}"
                @click="sfx_play_click()"
                size="is-small") テスト

              //- .card.is-size-7
              //-   .card-content.is_line_break_on.has-background-white-ter
              //-     b-tag.mr-1(type="is-danger" v-if="!e.success" rounded) 反則
              //-     | {{e.name}}
              //-     p
              //-       | {{$gs.str_strip(e.body)}}
              //-   .card-footer
              //-     nuxt-link.card-footer-item(
              //-       :to="{name: 'adapter', query: {body: $gs.str_strip(e.body)}}"
              //-       @click.native="sfx_play_click()") TEST
              //-
              //- nav.panel
              //-   .panel-heading
              //-     b-tag.mr-1(type="is-danger" v-if="!e.success" rounded) 反則
              //-     | {{e.name}}
              //-   .panel-block
              //-     | {{$gs.str_strip(e.body)}}
              //-   .panel-block
              //-     b-button(
              //-       expanded
              //-       outlined
              //-       tag="nuxt-link"
              //-       :to="{name: 'adapter', query: {body: $gs.str_strip(e.body)}}"
              //-       @click="sfx_play_click()"
              //-       size="is-small") テスト

</template>

<script>
import { TryFormatInfo } from "./models/try_format_info.js"

export default {
  name: "AdapterFormat",
  mounted() {
    this.app_log("対応形式確認")
  },
  computed: {
    TryFormatInfo() { return TryFormatInfo },
    meta() {
      return {
        title: ["対応形式確認", "なんでも棋譜変換"],
        description: "なんでも棋譜変換に放り込める形式のテスト",
        og_image_key: "adapter",
      }
    },
  },
}
</script>

<style lang="sass">
.AdapterFormat
  .title:not(:first-child)
    margin-top: 3rem

  .MainNavbar
    .container
      +mobile
        padding: 0

  .MainSection.section
    +tablet
      padding: 2.0rem 0.75rem

  .source_pre
    padding: 0.5rem
    white-space: pre-wrap
    word-break: break-all
    font-size: $size-7
</style>
