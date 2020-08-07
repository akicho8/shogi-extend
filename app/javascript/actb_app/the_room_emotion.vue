<template lang="pug">
.the_room_emotion.footer_nav.is-flex
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🥺', say: 'ぴえん'})") 🥺
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❗❓', say: ''})") ❗❓
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❗', say: 'びっくり'})") ❗
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '💯', say: '100点'})") 💯
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '👍', say: 'すごい！'})") 👍
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🍣', say: 'どーぞ'})") 🍣
  //- .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '🍰', say: 'どーぞ'})") 🍰
  .item.is_clickable.is-size-5(@click.stop="app.emotion_handle({type: 'is-light', plain: '❓', say: 'わからん？'})") ❓
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
