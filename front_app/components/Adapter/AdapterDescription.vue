<template lang="pug">
.AdapterDescription
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") 対応フォーマット

  MainSection
    .container
      .columns.is-multiline
        template(v-for="(e, i) in AdapterTestInfo.values")
          .column.mt-5.is-one-quarter-desktop.is-one-third-tablet
            .content
              .title.is-6.is-inline-block.is-marginless
                templete(v-if="!e.success")
                  | 【反則】
                | {{e.name}}
              b-field.mt-3
                b-input(:value="e.striped_body" readonly :rows="6" type="textarea")
              b-button(tag="nuxt-link" :to="{name: 'adapter', query: {body: e.striped_body}}" @click="sound_play('click')" size="is-small") テスト
</template>

<script>
import { AdapterTestInfo } from "@/components/models/AdapterTestInfo.js"

export default {
  name: "AdapterDescription",
  mounted() {
    this.ga_click("対応フォーマット")
  },
  computed: {
    meta() {
      return {
        title: ["対応フォーマット", "なんでも棋譜変換"],
      }
    },
    AdapterTestInfo() { return AdapterTestInfo },
  },
}
</script>

<style lang="sass">
.AdapterDescription
</style>
