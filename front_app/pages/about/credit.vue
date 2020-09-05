<template lang="pug">
.credit
  .content
    h2 クレジット (利用素材)
    hr

    h4 画像

    ul
      li
        a(href="http://sozai.7gates.net/docs/japanese-chess/") 将棋駒と将棋盤 画像フリー素材 | 無料素材倶楽部
      li
        a(href="http://mucho.girly.jp/bona/") CC Resources for Shogi Applications | 将棋アプリ用クリエイティブコモンズ画像
      li
        a(href="https://www.beiz.jp/") フリー画像素材 - BEIZ Graphics
      li
        a(href="https://www.pakutaso.com/") ぱくたそ-フリー素材・無料写真ダウンロード
      li
        a(href="http://free-paper-texture.com/") Paper-co | 紙のテクスチャー素材を無料でダウンロードできるサイト
      li
        a(href="https://free-texture.net/seamless-pattern/tatami01.html") フリーテクスチャ素材館／畳のテクスチャ素材01
      li
        a(href="https://www.irasutoya.com/") かわいいフリー素材集 いらすとや
      li
        a(href="https://twitter.com/Shogi_Zuan") 将棋図案駒

    h4 音
    ul
      li
        a(href="http://shineleckoma.web.fc2.com/") しんえれ外部駒 (駒音)
      li
        a(href="https://www.samplescience.ca/2018/03/8-bit-fx.html") 8 bit FX | SampleScience
      li
        a(href="https://otologic.jp") BGM・ジングル・効果音のフリー素材｜OtoLogic
      li
        a(href="https://soundeffect-lab.info/") 効果音ラボ
      li
        a(href="http://commons.nicovideo.jp/material/nc141655") ニコニ･コモンズ

    h4 フォント
    ul
      li
        a(href="https://www.rs.tus.ac.jp/yyusa/ricty_diminished.html") Ricty Diminished フォント
</template>

<script>
import autolinker from 'autolinker'

export default {
  name: "credit",
  layout: "about",
  methods: {
    auto_link(str, options = {}) {
      return autolinker.link(str, {newWindow: true, truncate: null, mention: "twitter", ...options})
    },
  },
}
</script>

<style lang="sass">
.credit
  h4
    margin-top: 1.75rem
</style>
