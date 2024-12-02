<template lang="pug">
.SwarsUserShowHeadBadge(v-if="TheApp.info.badge_items.length >= 1")
  .badges_line.is_scroll_x.is_scrollbar_invisible
    XemojiWrap.raw(v-for="e in TheApp.info.badge_items" @click="TheApp.badge_click_handle(e)" :class="{'is-clickable': e.message}" :str="e.icon")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowHeadBadge",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowHeadBadge
  margin-top: 0.1rem

  // バッジが少ないとき中央配置させるため
  display: flex
  justify-content: center
  align-items: center
  flex-direction: column

  .badges_line
    text-align: center
    white-space: nowrap         // nowrap:一行スクロールモード wrap:改行モード (ここだけで切り替え可)
    max-width: 100%             // 重要。width だと数が少ないとき左寄せになってしまう。

  .XemojiWrap
    flex-shrink: 0              // 縮小して消えるのを防ぐ
    margin: auto 0.1rem

.x-STAGE-development
  .SwarsUserShowHeadBadge
    .badges_line
      border: 1px dashed $blue
    .XemojiWrap
      border: 1px dashed $orange
      font-size: 3rem
</style>
