<template lang="pug">
.AdapterBookmarklet
  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'adapter'}")
      b-navbar-item.has-text-weight-bold(tag="div") ブックマークレット

  MainSection
    .container.is-fluid

      b-notification(:closable="false")
        .title.is-5 棋譜取得の予約について
        p
          | 将棋ウォーズ棋譜検索は将棋ウォーズの公式(以下本家)とは同期していません。
          | 検索と名前をつけているものの<b>直近の対局の検討を目的としている</b>のと本家への負荷軽減やレスポンス速度の兼ね合いもあり、検索時に本家から取得するのは各ルール直近10件だけにしています。
        p
          | そのため多く対戦していても検索すると思ったより件数が少なかったり抜けができたりします。
          | たとえば3分を15戦したあと検索しても直近の10局しか取り込んでないため最初の5局が見当たりません。
          | 最初の5局に検討したい対局があった場合は困るでしょう。
        p
          | そんなときに<b>棋譜取得の予約</b>をすると残りの5局を取得します。
          | 最大<b>直近1ヶ月</b>分を深夜に取得し、終わったら指定のメールアドレスに通知します。
        p
          | その際に棋譜データも必要であればZIPファイルの添付を有効にしてください。
          | ZIPファイルには文字コード UTF-8 と Shift_JIS の両方を含むので読めないときは Shift_JIS の方を試してください。

      template(v-for="e in BookmarkletInfo.values")
        .block
          p
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

  .notification
    padding-right: 1.25rem // notification はクローズボタンを考慮して右のpaddingが広くなっているため左と同じにする
    p:not(:first-child)
      margin-top: 0.75rem
</style>
