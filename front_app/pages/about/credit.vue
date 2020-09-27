<template lang="pug">
.about-credit
  .content
    .title.is-4.has-text-centered-mobile クレジット 
    .subtitle.is-6.has-text-centered-mobile 利用素材
    hr

    h4 画像

    ul
      li
        a(href="http://sozai.7gates.net/docs/japanese-chess/") 無料素材倶楽部 将棋駒と将棋盤
      li
        a(href="http://mucho.girly.jp/bona/") 将棋アプリ用クリエイティブコモンズ画像
      li
        a(href="https://www.pakutaso.com/") ぱくたそ
      li
        a(href="http://free-paper-texture.com/") Paper-co
      li
        a(href="https://www.irasutoya.com/") かわいいフリー素材集 いらすとや
      li
        a(href="https://twitter.com/Shogi_Zuan") 将棋図案駒
      li
        a(href="https://www.beiz.jp/") BEIZ Graphics
      li
        a(href="https://free-texture.net/seamless-pattern/tatami01.html") フリーテクスチャ素材館

    h4 音
    ul
      li
        a(href="https://soundeffect-lab.info/") 効果音ラボ
      li
        a(href="https://otologic.jp") OtoLogic
      li
        a(href="http://commons.nicovideo.jp/material/nc141655") ニコニ･コモンズ
      li
        a(href="http://shineleckoma.web.fc2.com/") しんえれ外部駒 (駒音)
      li
        a(href="https://www.samplescience.ca/2018/03/8-bit-fx.html") SampleScience 8 bit FX

    h4 フォント
    ul
      li
        a(href="https://www.rs.tus.ac.jp/yyusa/ricty_diminished.html") Ricty Diminished
</template>

<script>
import autolinker from 'autolinker'

export default {
  name: "about-credit",
  layout: "about",
  methods: {
    auto_link(str, options = {}) {
      return autolinker.link(str, {newWindow: true, truncate: null, mention: "twitter", ...options})
    },
  },
}
</script>

<style lang="sass">
.about-credit
  h4
    margin-top: 1.75rem
</style>
