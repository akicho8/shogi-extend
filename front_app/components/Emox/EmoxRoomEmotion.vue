<template lang="pug">
.EmoxRoomEmotion.footer_nav.is-flex.is-unselectable
  template(v-for="row in base.EmotionInfo.values")
    .item.is-clickable.is-size-5(@click.stop="base.emotion_handle({message: row.message, voice: row.voice})") {{row.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "EmoxRoomEmotion",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "support.sass"

.EmoxRoomEmotion
  &.footer_nav
    border-top: 1px solid $grey-lighter
    background-color: change_color($white-ter, $alpha: 0.96)

    z-index: 1

    position: fixed
    left: 0
    bottom: 0

    height: 64px
    width: 100%

    padding: 0 16px

    justify-content: space-between
    align-items: center

    +desktop
      justify-content: center
      .button, .item
        margin-left: 3rem
        margin-right: 3rem
</style>
