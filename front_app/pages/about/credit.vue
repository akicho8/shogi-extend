<template lang="pug">
.about-credit.has-background-black.has-text-centered
  b-icon.back_button.is-clickable(icon="chevron-left" size="is-medium" @click.native="back_handle")

  .section_title.texture.mt-0 TEXTURE
  ul
    li: ExternalLink(beep href="http://mucho.girly.jp/bona/") 将棋ｱﾌﾟﾘ用ｸﾘｴﾃｨﾌﾞｺﾓﾝｽﾞ画像
    li: ExternalLink(beep href="http://free-paper-texture.com/") Paper-co
    li: ExternalLink(beep href="https://www.irasutoya.com/") いらすとや
    li: ExternalLink(beep href="https://www.beiz.jp/") BEIZ Graphics
    li: ExternalLink(beep href="https://twitter.com/Shogi_Zuan") 将棋図案駒
    li: ExternalLink(beep href="https://nureyon.com/") ぬれよん
    li: ExternalLink(beep href="https://glyphwiki.org/") グリフウィキ
    li: ExternalLink(beep href="https://studio.beatnix.co.jp/") コドモとアプリ
    li: ExternalLink(beep href="https://github.com/orangain/shogi-piece-images") orangain/shogi-piece-images
    li: ExternalLink(beep href="http://putiya.com/") プチッチ

  .section_title SOUND EFFECT
  ul
    li: ExternalLink(beep href="https://assetstore.unity.com/packages/audio/sound-fx/universal-sound-fx-17256") UNIVERSAL SOUND FX
    li: ExternalLink(beep href="https://soundeffect-lab.info/") 効果音ラボ
    li: ExternalLink(beep href="https://otologic.jp") OtoLogic

  .section_title 実戦詰将棋『一期一会』問題集
  ul
    li: ExternalLink(beep href="https://yaneuraou.yaneu.com/2020/12/25/christmas-present/") やねうら王公式ｸﾘｽﾏｽﾌﾟﾚｾﾞﾝﾄ詰将棋500万問より

  .section_title THANKS
  ul.thanks
    li
      ExternalLink.is-block(beep href="https://www.studiok-i.net/piyo_shogi/") ぴよ将棋
      //- li.mt-1
      //-   .sub_text.is-size-7 公式
      //-   ExternalLink.is-block(beep href="https://twitter.com/STUDIOKPONTA") @STUDIOKPONTA
      //- .sub_text 開発
      ExternalLink.is-block.creator.mt-1(beep href="https://www.studiok-i.net/about.html") STUDIO-K

    li
      ExternalLink.is-block(beep href="https://twitter.com/shogi_kento") KENTO
      //- li.mt-1
      //-   .sub_text.is-size-7 公式
      //-   ExternalLink.is-block(beep href="https://twitter.com/shogi_kento") @shogi_kento
      //- .sub_text 開発
      ExternalLink.is-block.creator(beep href="https://twitter.com/na_o_ys") na-o-ys

    li
      ExternalLink.is-block(beep href="https://shogiwars.heroz.jp/") 将棋ウォーズ
      //- .sub_text 開発
      ExternalLink.is-block.creator.mt-1(beep href="https://heroz.co.jp/") HEROZ
</template>

<script>
export default {
  name: "about-credit",
  methods: {
    back_handle() {
      this.sound_play("click")
      this.back_to()
    },
  },
  computed: {
    meta() {
      return {
        title: "クレジット",
      }
    },
  },
}
</script>

<style lang="sass">
.about-credit
  min-height: 100vh
  padding: 4rem 0 6rem
  color: $white-ter
  font-weight: bold

  ul
    margin-top: 0.5rem
    li
      @extend .block

  .block:not(:last-child)
    margin-bottom: 0.5rem

  a
    font-size: $size-5
    display: inline-block
    color: inherit
    &.creator
      line-height: 100%
      font-size: $size-3

  .section_title
    margin-top: 5rem
    display: inline-block
    color: #ffa305
    font-weight: normal

  .thanks
    li
      margin-top: 2rem
      &.kento
        .creator
          font-size: $size-3 * 1.25

    .sub_text
      font-weight: normal
      font-size: $size-6
      margin-top: 0.75rem

  .back_button
    position: fixed
    top: 0
    left: 0
    padding: 2.0rem 1.75rem

.STAGE-development
  .about-credit
    .section_title, ul, li, .back_button
      border: 1px dashed change_color($primary, $alpha: 0.2)
</style>
