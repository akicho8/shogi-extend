<template lang="pug">
.ShareBoardAvatarLine(v-bind="$attrs" v-on="$listeners")
  // すべて名前が入力されていないとだめ
  template(v-if="info.from_user_name")
    // replace_icon が最優先
    template(v-if="replace_icon")
      XemojiWrap.user_guardian.flex_item.is-flex(:str="replace_icon")

    template(v-else)
      // 自分プロフィール画像があるなら優先して表示する
      template(v-if="info.from_avatar_path")
        img.avatar_img.flex_item(:src="info.from_avatar_path")

      // 自分プロフィール画像がないかつ守護獣モードなら守護獣表示
      template(v-if="info.from_avatar_path == null && base.guardian_display_key === 'is_guardian_display_on'")
        XemojiWrap.user_guardian.flex_item.is-flex(:str="default_guardian")

    // 名前
    XemojiWrap.user_name.flex_item(:str="info.from_user_name")
  slot
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "ShareBoardAvatarLine",
  mixins: [support_child],
  props: {
    info:         { type: Object, required: true },
    replace_icon: { type: String, required: false },
  },
  computed: {
    default_guardian() { return this.base.guardian_from_str(this.info.from_user_name) },
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

  gap: 0.25rem
  line-height: 1.75

  .flex_item
    // 基本横1行の設定とする
    flex-shrink: 0  // 縮小禁止 = テキストが折り返し抑制 (発言などの場合はオーバーライドして1にすること)

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
      // color: $primary

.ShareBoardApp.debug_mode_p
  .ShareBoardAvatarLine
    // flex-wrap: wrap
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
