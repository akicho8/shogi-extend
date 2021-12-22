<template lang="pug">
.AdapterBookmarklet
  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") ブックマークレット

  MainSection
    .container.is-fluid
      template(v-for="e in BookmarkletInfo.values")
        .block
          .title.is-6.mb-0
            | {{e.description}}
          pre.mt-2
            | {{bookmark_url_for(e)}}
          a.button.is-small.mt-2(:href="bookmark_url_for(e)")
            | {{e.name}}
</template>

<script>
import { BookmarkletInfo } from "./models/bookmarklet_info.js"

export default {
  name: "AdapterBookmarklet",
  methods: {
    bookmark_url_for(e) {
      const v = e.func(this)
      return ["javascript", v].join(":")
    },
  },
  computed: {
    BookmarkletInfo() { return BookmarkletInfo },
    adapter_url()     { return `${this.$config.MY_NUXT_URL}/adapter` },
    meta() {
      return {
        title: ["ブックマークレット", "なんでも棋譜変換"],
        description: "なんでも棋譜変換にコピペして外部アプリを起動するような処理を自動化する方法の紹介",
      }
    },
  },
}
</script>

<style lang="sass">
.AdapterBookmarklet
  .MainNavbar
    .container
      +mobile
        padding: 0

  .MainSection.section
    +tablet
      padding: 2.0rem 0.75rem

  pre
    padding: 0.5rem
    white-space: pre-wrap
    word-break: break-all
    font-size: $size-7
</style>
