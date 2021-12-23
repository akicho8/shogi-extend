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
          p
            | {{e.description}}
          pre.mt-2
            | {{bookmark_url_for(e)}}
          a.button.is-small.mt-2(:href="bookmark_url_for(e)")
            | {{e.name}}

      b-notification(:closable="false")
        //- .title.is-6.mb-3 引数
        .content
          h6 引数
          dl
            .dtd
              dt body
              dd
                | テキストエリアに貼り付ける入力値。<br>
                | ブックマークレットの場合は基本 <code>location.href</code> を渡す。
            .dtd
              dt app_to
              dd
                | 読み取り後に渡すアプリ
                ul.mt-1
                  li <code>piyo_shogi</code> ぴよ将棋
                  li <code>kento</code> KENTO
                  li <code>share_board</code> 共有将棋盤
            .dtd
              dt tab
              dd
                | ぴよ将棋やKENTOを新しいタブで開くかどうかを強制指定
                ul.mt-1
                  li <code>new</code> 新しいタブで開く(PCの初期値)
                  li <code>self</code> 新しいタブで開かない(スマホの初期値)
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
        og_image_key: "adapter",
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

  .notification
    padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする
    p:not(:first-child)
      margin-top: 0rem

  .content
    .dtd
      margin-top: 0.5rem
      dt
        font-weight: bold
      dd
        margin-top: 0.25rem
    code
      background-color: unset
</style>
