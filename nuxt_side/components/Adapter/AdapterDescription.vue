<template lang="pug">
.AdapterDescription
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") 対応フォーマットの確認

  MainSection
    .container
      template(v-for="(e, i) in AdapterTestInfo.values")
        .title.is-4 {{e.name}}
        .columns.is-multiline
          template(v-for="e in e.items")
            .column.mt-5.is-one-quarter-desktop.is-one-third-tablet
              .content
                .title.is-6.is-inline-block.is-marginless
                  template(v-if="!e.success")
                    | 【反則】
                  | {{e.name}}
                b-field.mt-3
                  b-input(:value="_.trim(e.body)" readonly :rows="6" type="textarea")
                b-button(tag="nuxt-link" :to="{name: 'adapter', query: {body: _.trim(e.body)}}" @click="sound_play_click()" size="is-small") テスト
</template>

<script>
import _ from "lodash"
import { AdapterTestInfo } from "@/components/models/adapter_test_info.js"

export default {
  name: "AdapterDescription",
  mounted() {
    this.ga_click("対応フォーマットの確認")
  },
  computed: {
    meta() {
      return {
        title: ["対応フォーマットの確認", "なんでも棋譜変換"],
      }
    },
    _()               { return _               },
    AdapterTestInfo() { return AdapterTestInfo },
  },
}
</script>

<style lang="sass">
.AdapterDescription
  .title:not(:first-child)
    margin-top: 5rem
</style>
