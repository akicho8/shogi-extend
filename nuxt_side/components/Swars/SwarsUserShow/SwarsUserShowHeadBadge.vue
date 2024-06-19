<template lang="pug">
.SwarsUserShowHeadBadge(v-if="TheApp.info.badge_items.length >= 1")
  .one_element(v-for="e in TheApp.info.badge_items" @click="TheApp.badge_click_handle(e)" :class="{'is-clickable': e.message}")
    XemojiWrap.raw(:str="e.icon")
    //- template(v-if="false")
    //- b-tag(          v-else-if="e.method === 'tag'" :type="e.type" rounded) {{e.icon}}
    //- XemojiWrap.raw( v-else-if="e.method === 'raw'" :str="e.icon")
    //- b-icon(         v-else-if="e.method === 'icon'" :icon="e.icon" :type="e.type" size="is-small")
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

  display: flex
  justify-content: center
  align-items: center

  overflow-x: hidden
  overscroll-behavior-x: none

  .one_element
    flex-shrink: 0              // 縮小して消えるのを防ぐ

    margin: auto 0.1rem
    .raw
      // position: relative
      // bottom: -0.2rem     // 絵文字は大きいので若干下げる
      .xemoji
        // デフォルト 1em
        // height: 1em
        // width: 1em
    // .icon
    //   position: relative
    //   bottom: -0.1rem
</style>
