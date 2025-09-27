<template lang="pug">
// @click.native="sfx_play_click()" すると2連続で呼ばれてしまうので指定してない
// @click.native="toast_ok(1)" すると2回呼ばれていることがわかる
b-upload.WkbkBookEditFormUpload(@input="base.upload_handle" @click.native="debug_alert('2回呼ばれる不具合があるため効果音OFF')")
  figure.image.is-clickable
    img(:src="base.image_source")
    .position_center
      b-icon.has-text-white(icon="camera" size="is-large")
    .position_top_left
      .size_info.is-size-7
        | 1200x630 推奨
    .position_bottom_right(v-if="base.image_source_exist_p")
      .icon_box(@click.prevent.stop="base.upload_delete_handle")
        b-icon.has-text-white(icon="trash-can")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookEditFormUpload",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookEditFormUpload
  .image
    // img
    //   +desktop
    //     width: calc(1200px * 0.5)
    //     height: calc(630px * 0.5)

    // 中央のカメラ
    .position_center
      position: absolute
      top: 0
      width: 100%
      height: 100%

      display: flex
      align-items: center
      justify-content: center
      flex-direction: column

      .icon
        filter: drop-shadow(0px 0px 12px hsla(0, 0%, 0%, 1.0))

    // "1200x630 推奨"
    .position_top_left
      position: absolute
      top: 0
      left: 0
      .size_info
        margin: 6px
        padding: 0.25rem 0.6rem
        color: $white
        background-color: change_color($black, $alpha: 0.6)
        font-weight: bold
        border-radius: 3px

    // 削除
    .position_bottom_right
      position: absolute
      bottom: 0
      right: 0
      .icon_box
        margin: 6px
        padding: 0.4rem 0.4rem 0.2rem
        background-color: change_color($black, $alpha: 0.6)
        border-radius: 3px
        .icon
          filter: drop-shadow(0px 0px 12px hsla(0, 0%, 0%, 1.0))
</style>
