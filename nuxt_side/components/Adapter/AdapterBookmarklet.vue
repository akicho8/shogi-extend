<template lang="pug">
.AdapterBookmarklet
  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") ブックマークレット

  MainSection
    .container.is-fluid
      .notification.is-success.is-light
        | 下から必要なリンクをブックマークバーにドラッグしてください

      template(v-for="e in BookmarkletInfo.values")
        .block
          a.bookmark_url.is-size-5(:href="bookmark_url_for(e)")
            b-icon(icon="link")
            | {{e.name}}
          p
            | {{e.title}}
          p(v-if="e.description")
            | {{e.description}}
          pre.mt-2
            | {{bookmark_url_for(e)}}

      b-notification.mt-6(:closable="false")
        .content
          h4 引数
          dl
            .dtd
              dt body
              dd
                | 入力値。これだけ必須。現在のURLとして <code>location.href</code> を渡しとけばいい。
                | 選択範囲は <code>getSelection().toString()</code> で取れる。
            .dtd
              dt open
              dd
                | 読み取り後に開くアプリ
                ul.mt-1
                  li <code>piyo_shogi</code>
                  li <code>kento</code>
                  li <code>share_board</code>
                  li <code>video_new</code>
            .dtd
              dt open_target
              dd
                | ぴよ将棋やKENTOの開き方
                ul.mt-1
                  li <code>_blank</code> 新しいタブ(PC初期値)
                  li <code>_self</code> 既存タブ(スマホ初期値)
            .dtd
              dt turn
              dd
                | アプリを開くときの手数(局面)<br>
                | 読み込む棋譜が詰将棋とわかっているときに <code>turn=0</code> を渡したら最初の局面で開く
                ul.mt-1
                  li <code>数字</code> その手数の局面(マイナスなら後ろから数える)
                  li <code>0</code> 最初の局面
                  li <code>1</code> 1手指した直後の局面
                  li <code>-1</code> 最後の局面
                  li <code>-2</code> 最後から一つ前の局面
                  li <code>数字以外</code> 最後の局面(初期値)
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

  .bookmark_url
    .icon
      vertical-align: text-top

  .content
    .dtd
      margin-top: 0.5rem
      dt
        font-weight: bold
      dd
        margin-top: 0.25rem
        word-break: break-all
    code
      background-color: unset
</style>
