<template lang="pug">
.about-credit
  .content
    .title.is-4.has-text-centered-mobile クレジット
    hr

    h4 Apps
    ul
      li.mt-5
        ExternalLink(href="https://www.studiok-i.net/piyo_shogi/") ぴよ将棋
        ul
          li
            | 公式:
            ExternalLink.mx-1(href="https://twitter.com/STUDIOKPONTA") @STUDIOKPONTA
          li
            | 開発:
            ExternalLink.mx-1(href="https://www.studiok-i.net/about.html") 株式会社スタジオケイ
      li.mt-5
        ExternalLink(href="https://www.kento-shogi.com/") KENTO
        ul
          li
            | 公式:
            ExternalLink.mx-1(href="https://twitter.com/shogi_kento") @shogi_kento
          li
            | 開発:
            ExternalLink.mx-1(href="https://twitter.com/na_o_ys") @na_o_ys
            | さん

    h4.mt-6 画像
    ul
      li
        ExternalLink(href="http://sozai.7gates.net/docs/japanese-chess/") 無料素材倶楽部
      li
        ExternalLink(href="http://mucho.girly.jp/bona/") 将棋アプリ用クリエイティブコモンズ画像
      li
        ExternalLink(href="https://www.pakutaso.com/") ぱくたそ
      li
        ExternalLink(href="http://free-paper-texture.com/") Paper-co
      li
        ExternalLink(href="https://www.irasutoya.com/") いらすとや
      li
        ExternalLink(href="https://twitter.com/Shogi_Zuan") 将棋図案駒
      li
        ExternalLink(href="https://www.beiz.jp/") BEIZ Graphics
      li
        ExternalLink(href="https://free-texture.net/seamless-pattern/tatami01.html") フリーテクスチャ素材館

    h4.mt-6 サウンド
    ul
      li
        ExternalLink(href="https://assetstore.unity.com/packages/audio/sound-fx/universal-sound-fx-17256") UNIVERSAL SOUND FX
      li
        ExternalLink(href="https://soundeffect-lab.info/") 効果音ラボ
      li
        ExternalLink(href="https://otologic.jp") OtoLogic
</template>

<script>
export default {
  name: "about-credit",
  layout: "about",
}
</script>

<style lang="sass">
.about-credit
</style>
