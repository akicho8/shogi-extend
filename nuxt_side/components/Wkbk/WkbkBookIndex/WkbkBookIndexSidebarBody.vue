<template lang="pug">
.WkbkBookIndexSidebarBody
  b-menu
    b-menu-list(label="コンテンツ")
      b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles'}" label="問題リスト"   @click.native="$sound.play_click()")
      b-menu-item(tag="nuxt-link" :to="{name: 'rack-books'}"    label="問題集リスト" @click.native="$sound.play_click()")

    b-menu-list(label="表示オプション" v-if="base.visible_hash")
      b-menu-item.is_active_unset.sidebar_columns_toggle(@click="$sound.play_click()")
        template(slot="label" slot-scope="props")
          | 表示カラム
          b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
        template(v-for="e in base.BookIndexColumnInfo.values")
          b-menu-item.is_active_unset(
            v-if="e.togglable"
            @click.stop="base.cb_toggle_handle(e)"
            :class="{is_visible_off: !base.visible_hash[e.key], is_visible_on: base.visible_hash[e.key]}"
            :key="e.key"
            :label="e.name"
            )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookIndexSidebarBody
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .menu
      border: 1px dashed change_color($primary, $alpha: 0.5)

.is-fixed
  .WkbkBookIndexSidebarBody
    padding: 1.25rem 1rem

.is-static
  .WkbkBookIndexSidebarBody
    padding: 1rem 1rem

// 共通
.WkbkBookIndexSidebarBody
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
