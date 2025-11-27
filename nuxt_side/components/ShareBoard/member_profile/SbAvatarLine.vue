<template lang="pug">
// 外側で必ず key を指定すること
.SbAvatarLine(v-bind="$attrs" v-on="$listeners")
  // すべて名前が入力されていないとだめ
  .name_block(v-if="info.from_user_name")
    // 絵文字表示順序
    //  (1) 置き換え
    //  (2) 優先絵文字
    //  (3) 自分プロフィール画像
    //  (4) アバター画像
    template(v-if="replace_icon")
      XemojiWrap.user_guardian.flex_item.is-flex(:str="replace_icon")
    template(v-else-if="info.primary_emoji")
      XemojiWrap.user_guardian.flex_item.is-flex(:str="info.primary_emoji")
    template(v-else-if="info.from_avatar_path")
      img.avatar_img.flex_item(:src="info.from_avatar_path")
    template(v-else)
      XemojiWrap.user_guardian.flex_item.is-flex(:str="avatar_char")

    // 名前
    XemojiWrap.user_name.flex_item(:str="info.from_user_name")

    // バッジ
    XprofileShow.flex_item.is-size-7(v-if="xprofile_show_p" :name="info.from_user_name")
  slot
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbAvatarLine",
  mixins: [support_child],
  props: {
    info:            { type: Object, required: true  },
    replace_icon:    { type: String, required: false },
    xprofile_show_p: { type: Boolean, default: true  },
  },
  computed: {
    avatar_char()   { return this.SB.name_to_avatar_char(this.info.from_user_name)          },
    xprofile_decorator() { return this.SB.xprofile_decorator_by_name(this.info.from_user_name) },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.SbAvatarLine
  line-height: 1.75  // 以下共通とする

  // width: 100%
  display: flex
  // align-items: flex-start
  align-items: center
  justify-content: flex-start
  gap: 0.25rem

  .flex_item
    white-space: nowrap // 上書きする場合もある

  .name_block
    flex-shrink: 0
    display: flex
    align-items: center
    gap: 0.25rem

  .avatar_img, .xemoji
    width: 24px
    height: 24px

  .avatar_img
    display: block           // inlineだと余計な隙間が生まれるため念のためblockにしておく
    border-radius: 100%      // 丸める

.STAGE-development, .SbApp.debug_mode_p
  .SbAvatarLine
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
