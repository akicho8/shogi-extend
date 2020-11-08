<template lang="pug">
.the_room_emotion.footer_nav.is-flex.is-unselectable
  template(v-for="row in current_emotions")
    .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({message: row.message, voice: row.voice})") {{row.name}}

  //- template(v-if="base.question_mode_p")
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🥺', say: 'ぴえん'})") 🥺
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❗❓', say: ''})") ❗❓
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '👍', say: 'すごい！'})") 👍
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '💯', say: '100点'})") 💯
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❗', say: 'びっくり'})") ❗
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🍣', say: 'どーぞ'})") 🍣
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'むずい', say: 'むずい'})") 難
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'かんたん', say: 'かんたん'})") 簡
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🍰', say: 'どーぞ'})") 🍰
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❓', say: 'わからん'})") ❓
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '相手の指し手は自分で操作するらしいよ', say: '相手の指し手は自分で操作するらしいよ。めんどくさいですね'})") 伝
  //-   //- b-icon.item(icon="thumb-up" @click.stop.native="base.emotion_handle({type: 'is-light', message: 'いいね'})")
  //- template(v-if="base.versus_mode_p")
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🥺', say: 'ぴえん'})") 🥺
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❗❓', say: ''})") ❗❓
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '👍', say: 'すごい！'})") 👍
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '💯', say: '100点'})") 💯
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❗', say: 'びっくり'})") ❗
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🍣', say: 'どーぞ'})") 🍣
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'むずい', say: 'むずい'})") 難
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'かんたん', say: 'かんたん'})") 簡
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '🍰', say: 'どーぞ'})") 🍰
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '❓', say: 'わからん'})") ❓
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
  //-   //- .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'びっくり', say: 'びっくり'})") び
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'ただやん', say: 'ただやん'})") た
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: 'やばい', say: 'やばい'})") や
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
  //-   .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "the_room_emotion",
  mixins: [
    support_child,
  ],
  computed: {
    current_emotions() {
      let v = this.base.current_user.emotions
      if (v.length === 0) {
        v = this.base.EmotionInfo.values
      }
      v = v.filter(e => e.folder_key === this.base.emotion_folder_key)
      return v
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_emotion
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)
</style>
