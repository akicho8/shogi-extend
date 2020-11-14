<template lang="pug">
.EmoxRoomEmotion.footer_nav.is-flex.is-unselectable
  template(v-for="row in base.EmotionInfo.values")
    b-tooltip(:label="row.message")
      .item.is-clickable.is-size-6.is-size-7-mobile.is-inline-flex.is-align-items-center.px-2(
        @click.stop="base.emotion_handle(row)"
        )
        | {{row.name}}
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

    .b-tooltip
      height: 100%
      .item
        height: 100%

    +desktop
      justify-content: center
      .b-tooltip
        margin-left: 3rem
        margin-right: 3rem

.STAGE-development
  .EmoxRoomEmotion
    .b-tooltip
      border: 1px dashed change_color($primary, $alpha: 0.5)
      .item
        border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
