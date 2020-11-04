<template lang="pug">
.EmoxRoomEmotion.footer_nav.is-flex.is-unselectable
  template(v-for="row in base.EmotionInfo.values")
    .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({message: row.message, voice: row.voice})") {{row.name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "EmoxRoomEmotion",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxRoomEmotion
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)
</style>
