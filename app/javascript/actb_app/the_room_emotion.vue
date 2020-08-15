<template lang="pug">
.the_room_emotion.footer_nav.is-flex.is-unselectable
  template(v-if="app.quiz_mode_p")
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🥺', say: 'ぴえん'})") 🥺
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❗❓', say: ''})") ❗❓
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '👍', say: 'すごい！'})") 👍
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '💯', say: '100点'})") 💯
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❗', say: 'びっくり'})") ❗
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🍣', say: 'どーぞ'})") 🍣
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'むずい', say: 'むずい'})") 難
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'かんたん', say: 'かんたん'})") 簡
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🍰', say: 'どーぞ'})") 🍰
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❓', say: 'わからん'})") ❓
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '相手の指し手は自分で操作するらしいよ', say: '相手の指し手は自分で操作するらしいよ。めんどくさいですね'})") 伝
    //- b-icon.item(icon="thumb-up" @click.stop.native="app.emotion_handle({type: 'is-light', message: 'いいね'})")
  template(v-if="app.versus_mode_p")
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🥺', say: 'ぴえん'})") 🥺
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❗❓', say: ''})") ❗❓
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '👍', say: 'すごい！'})") 👍
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '💯', say: '100点'})") 💯
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❗', say: 'びっくり'})") ❗
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🍣', say: 'どーぞ'})") 🍣
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'むずい', say: 'むずい'})") 難
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'かんたん', say: 'かんたん'})") 簡
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '🍰', say: 'どーぞ'})") 🍰
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '❓', say: 'わからん'})") ❓
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
    //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'びっくり', say: 'びっくり'})") び
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'ただやん', say: 'ただやん'})") た
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: 'やばい', say: 'やばい'})") や
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対よろ', say: 'よろしく'})") よ
    .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', message: '対あり', say: 'ありがとうございました'})") あ
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_room_emotion",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_emotion
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)
</style>
