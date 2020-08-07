<template lang="pug">
.the_menu_sound
  .primary_header
    .header_center_title サウンドテスト
  .menu_buttons
    b-button(expanded @click="sound_play('click')")   タップ
    b-button(expanded @click="sound_play('deden')")   ででん
    b-button(expanded @click="sound_play('poon')")    わかった
    b-button(expanded @click="sound_play('correct')") 正解
    b-button(expanded @click="sound_play('mistake')") 不正解
    b-button(expanded @click="sound_play('timeout')") 時間切れ
    b-button(expanded @click="sound_play('win')")     勝ち
    b-button(expanded @click="sound_play('lose')")    負け
    b-button(expanded @click="sound_play('draw')")    引き分け
    b-button(expanded @click="sound_play('pishi')")   駒音
    b-button(expanded @click="sound_play('bell1')")   挑戦者現る
    b-button(expanded @click="sound_play('bell2')")   ベル2 (未使用)
    b-button(expanded @click="sound_play('pon')")     ぽん (練習終了)
    b-button(expanded @click="sound_play('notify')")  コメント通知
    b-button(expanded @click="voice_exercise")        発声練習
    b-button(expanded @click="sound_play('spon')")    エモーション
    b-button(expanded @click="app.menu_to('the_menu_etc')") もどる
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_menu_sound",
  mixins: [
    support,
  ],
  methods: {
    voice_exercise() {
      this.say(_.sample(this.sentence_list))
    },
  },
  computed: {
    sentence_list() {
      return [
        "カッパ クッパ 食った",
        "裏庭には、二羽、鶏がいる",
        "ブタがブタをぶったらぶたれたブタがぶったブタをぶった。ぶったブタとぶたれたブタがぶっ倒れた",
      ]
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu_sound
</style>
