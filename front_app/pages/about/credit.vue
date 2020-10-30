<template lang="pug">
.about-credit.has-background-black.has-text-centered
  b-icon.back_button.is_clickable(icon="chevron-left" size="is-medium" @click.native="back_handle")

  .section_title.mt-0 SHOGI APPS
  ul.apps
    li.piyo_shogi
      ExternalLink(beep href="https://www.studiok-i.net/piyo_shogi/") ぴよ将棋
      //- li.mt-1
      //-   .sub_text.is-size-7 公式
      //-   ExternalLink(beep href="https://twitter.com/STUDIOKPONTA") @STUDIOKPONTA
      .sub_text 開発
      ExternalLink.creator.mt-1(beep href="https://www.studiok-i.net/about.html") STUDIO-K

    li.kento
      ExternalLink(beep href="https://twitter.com/shogi_kento") KENTO
      //- li.mt-1
      //-   .sub_text.is-size-7 公式
      //-   ExternalLink(beep href="https://twitter.com/shogi_kento") @shogi_kento
      .sub_text 開発
      ExternalLink.creator(beep href="https://twitter.com/na_o_ys") na-o-ys

  .section_title.texture TEXTURE
  ul.mt-3
    li.my-2
      ExternalLink(beep href="http://sozai.7gates.net/docs/japanese-chess/") 無料素材倶楽部
    li.my-2
      ExternalLink(beep href="http://mucho.girly.jp/bona/") 将棋ｱﾌﾟﾘ用ｸﾘｴﾃｨﾌﾞｺﾓﾝｽﾞ画像
    li.my-2
      ExternalLink(beep href="https://www.pakutaso.com/") ぱくたそ
    li.my-2
      ExternalLink(beep href="http://free-paper-texture.com/") Paper-co
    li.my-2
      ExternalLink(beep href="https://www.irasutoya.com/") いらすとや
    li.my-2
      ExternalLink(beep href="https://www.beiz.jp/") BEIZ Graphics
    li.my-2
      ExternalLink(beep href="https://free-texture.net/seamless-pattern/tatami01.html") フリーテクスチャ素材館
    li.my-2
      ExternalLink(beep href="https://twitter.com/Shogi_Zuan") 将棋図案駒

  .section_title SOUND EFFECT
  ul.mt-3
    li.my-2
      ExternalLink(beep href="https://assetstore.unity.com/packages/audio/sound-fx/universal-sound-fx-17256") UNIVERSAL SOUND FX
    li.my-2
      ExternalLink(beep href="https://soundeffect-lab.info/") 効果音ラボ
    li.my-2
      ExternalLink(beep href="https://otologic.jp") OtoLogic
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
}
</script>

<style lang="sass">
.about-credit
  min-height: 100vh
  padding: 4rem 0 6rem
  color: $white
  font-weight: bold

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
    color: $white
    font-weight: normal

  .apps
    li
      margin-top: 3rem
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
