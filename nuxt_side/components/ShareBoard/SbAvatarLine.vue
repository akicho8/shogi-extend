<template lang="pug">
// 外側で必ず key を指定すること
.SbAvatarLine(v-bind="$attrs" v-on="$listeners")
  // すべて名前が入力されていないとだめ
  template(v-if="info.from_user_name")
    // replace_icon が最優先
    template(v-if="replace_icon")
      XemojiWrap.user_guardian.flex_item.is-flex(:str="replace_icon")

    template(v-else)
      // 自分プロフィール画像があるなら優先して表示する
      template(v-if="info.from_avatar_path")
        img.avatar_img.flex_item(:src="info.from_avatar_path")

      // 自分プロフィール画像がないなら守護獣表示
      template(v-if="info.from_avatar_path == null")
        XemojiWrap.user_guardian.flex_item.is-flex(:str="default_guardian")

    // 名前
    XemojiWrap.user_name.flex_item(:str="info.from_user_name")

    // メダル
    UserMedal.flex_item.is-size-7(v-if="medal_show_p" :name="info.from_user_name")
  slot
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "SbAvatarLine",
  mixins: [support_child],
  inject: ["TheSb"],
  props: {
    info:            { type: Object, required: true  },
    replace_icon:    { type: String, required: false },
    medal_show_p: { type: Boolean, default: true  },
  },
  computed: {
    default_guardian() { return this.TheSb.guardian_from_str(this.info.from_user_name) },
    medal_decorator()  { return this.TheSb.medal_decorator_by_name(this.info.from_user_name)  },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.SbAvatarLine
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

.SbApp.debug_mode_p
  .SbAvatarLine
    // flex-wrap: wrap
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
