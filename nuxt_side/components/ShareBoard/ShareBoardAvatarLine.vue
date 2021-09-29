<template lang="pug">
.ShareBoardAvatarLine(v-bind="$attrs" v-on="$listeners")
  img.avatar_img.flex_item(:src="info.from_avatar_path" v-if="info.from_avatar_path")
  .user_guardian.flex_item.is-flex(v-if="base.guardian_mode === 'is_guardian_mode_on' && info.from_avatar_path == null" v-text="user_guardian" v-xemoji)
  .user_name.flex_item(v-text="info.from_user_name" v-xemoji)
  slot
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "ShareBoardAvatarLine",
  mixins: [support_child],
  props: {
    info: { type: Object, required: true },
  },
  computed: {
    user_guardian() { return this.base.guardian_from_str(this.info.from_user_name) },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardAvatarLine
  width: 100%

  display: flex
  align-items: center
  justify-content: flex-start

  .flex_item
    // 基本横1行の設定とする
    flex-shrink: 0  // 縮小禁止 = テキストが折り返し抑制 (発言などの場合はオーバーライドして1にすること)
    line-height: 1  // 高さを取っておく

    &:not(:first-child)
      margin-left: 0.25rem // 基本の隙間はここだけ
    &.avatar_img
      display: block // inlineだと余計な隙間が生まれるため念のためblockにしておく
      width: 24px
      height: 24px
      border-radius: 100%
    &.user_guardian
      .xemoji
        width: 24px
        height: 24px
    &.user_name
      color: $primary

.STAGE-development
  .ShareBoardAvatarLine
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
