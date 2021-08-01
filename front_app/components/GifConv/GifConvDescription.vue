<template lang="pug">
.GifConvDescription
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'gif_conv'}")
      b-navbar-item.has-text-weight-bold(tag="div") 対応フォーマットの確認

  MainSection
    .container
      template(v-for="(e, i) in GifConvTestInfo.values")
        .title.is-4 {{e.name}}
        .columns.is-multiline
          template(v-for="e in e.items")
            .column.mt-5.is-one-quarter-desktop.is-one-third-tablet
              .content
                .title.is-6.is-inline-block.is-marginless
                  templete(v-if="!e.success")
                    | 【反則】
                  | {{e.name}}
                b-field.mt-3
                  b-input(:value="_.trim(e.body)" readonly :rows="6" type="textarea")
                b-button(tag="nuxt-link" :to="{name: 'gif_conv', query: {body: _.trim(e.body)}}" @click="sound_play('click')" size="is-small") テスト
</template>

<script>
import _ from "lodash"
import { GifConvTestInfo } from "@/components/models/gif_conv_test_info.js"

export default {
  name: "GifConvDescription",
  mounted() {
    this.ga_click("対応フォーマットの確認")
  },
  computed: {
    meta() {
      return {
        title: ["対応フォーマットの確認", "アニメーションGIF変換"],
      }
    },
    _()               { return _               },
    GifConvTestInfo() { return GifConvTestInfo },
  },
}
</script>

<style lang="sass">
.GifConvDescription
  .title:not(:first-child)
    margin-top: 5rem
</style>
