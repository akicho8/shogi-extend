<template lang="pug">
// 外側で必ず key を指定すること
.SbAvatarLine(v-bind="$attrs" v-on="$listeners")
  .name_block
    template(v-if="prefix_icon.type === 'icon'")
      XemojiWrap.flex_item.is-flex(:str="prefix_icon.value")
    template(v-else)
      img.selfie_image.flex_item(:src="prefix_icon.value")

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
    system_icon:     { type: String, required: false },
    xprofile_show_p: { type: Boolean, default: true  },
  },
  computed: {
    avatar_char()        { return this.SB.AvatarSupport.char_from_str(this.info.from_user_name)        },
    xprofile_decorator() { return this.SB.xprofile_decorator_by_name(this.info.from_user_name) },

    prefix_icon() {
      return [
        { type: "icon",  value: this.system_icon               },
        { type: "icon",  value: this.info.primary_emoji        },
        { type: "icon",  value: this.info.user_selected_avatar },
        { type: "image", value: this.info.from_avatar_path     },
        { type: "icon",  value: this.avatar_char               },
      ].find(e => e.value)
    },
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

  .selfie_image, .xemoji
    width: 24px
    height: 24px

  .selfie_image
    display: inline-block    // 横並びの画像は inline-block にする
    border-radius: 100%      // 丸める

.SbApp.debug_mode_p
  .SbAvatarLine
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .flex_item
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
