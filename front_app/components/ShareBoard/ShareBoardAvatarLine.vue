<template lang="pug">
.ShareBoardAvatarLine(v-bind="$attrs" v-on="$listeners")
  img.avatar_img.flex_item(:src="info.from_avatar_path" v-if="info.from_avatar_path")
  .user_char.flex_item(v-if="info.from_avatar_path == null" v-text="user_char" v-xemoji)
  .user_name.flex_item(v-text="info.from_user_name" v-xemoji)
  slot
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardAvatarLine",
  mixins: [support_child],
  props: {
    info: { type: Object, required: true },
  },
  computed: {
    user_char() {
      const index = this.ruby_like_modulo(this.name_hash, this.emoji_list.length)
      return this.emoji_list[index]
    },

    // private

    emoji_list() { return [..."🐰🐥🦉🐔🦔🐻🐹🐷🐮🐯🦁🐱🦊🐺🐶🐵🐸🐛🦋🥀🍀☘🍄"] },

    name_hash() {
      const chars = [...this.info.from_user_name]
      const total = _.sumBy(chars, e => e.codePointAt(0))
      return total
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardAvatarLine
  width: 100%

  display: flex
  align-items: center
  justify-content: start

  .flex_item
    // 基本横1行の設定とする
    flex-shrink: 0  // 縮小禁止 = テキストが折り返し抑制 (発言などの場合はオーバーライドして1にすること)
    line-height: 1  // 高さを取っておく

    &:not(:first-child)
      margin-left: 0.25rem // 基本の隙間はここだけ
    &.avatar_img
      display: block // inlineだと余計な隙間が生まれるため念のためblockにしておく
      width: 2rem
      height: 2rem
      border-radius: 100%
    &.user_char
      font-size: 1.8rem // できれば wh = 2rem x 2rem としたいがフォントなので見た目で決める
    &.user_name
      color: $primary

.STAGE-development
  .ShareBoardAvatarLine
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
