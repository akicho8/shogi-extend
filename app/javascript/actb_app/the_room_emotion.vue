<template lang="pug">
.the_room_emotion.footer_nav.is-flex.is-unselectable(v-if="!app.room.bot_user_id || development_p || true")
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🥺', say: 'ぴえん'})") 🥺
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❗❓', say: ''})") ❗❓
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '👍', say: 'すごい！'})") 👍
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '💯', say: '100点'})") 💯
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❗', say: 'びっくり'})") ❗
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🍣', say: 'どーぞ'})") 🍣
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: 'むずい', say: 'むずい'})") 難
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: 'かんたん', say: 'かんたん'})") 簡
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🍰', say: 'どーぞ'})") 🍰
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❓', say: 'わからん'})") ❓
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '対よろ', say: 'よろしく'})") よ
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '対あり', say: 'ありがとうございました'})") あ
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '相手の指し手は自分で操作するらしいよ', say: '相手の指し手は自分で操作するらしいよ。めんどくさいですね'})") 伝
  //- b-icon.item(icon="thumb-up" @click.stop.native="app.emotion_handle({type: 'is-light', plain: 'いいね'})")
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
