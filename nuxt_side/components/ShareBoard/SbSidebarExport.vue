<template lang="pug">
// なぜだかわからない b-menu-list.SbSidebarExport とはできない
.SbSidebarExport
  b-menu-list(label="EXPORT")
    slot

    b-menu-item.is_active_unset(icon="clipboard-plus-outline" @click="sfx_play_click()")
      template(slot="label" slot-scope="props")
        | 棋譜コピー
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        template(v-if="e.clipboard")
          b-menu-item.is_active_unset(:label="e.name_with_turn(base.current_turn)" @click="base.kifu_copy_handle(e)")

    b-menu-item.is_active_unset(icon="eye" :expanded="false" @click="sfx_play_click()")
      template(slot="label" slot-scope="props")
        | 棋譜表示
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        template(v-if="e.show")
          b-menu-item.is_active_unset(:label="e.name_with_turn(base.current_turn)" @click.prevent="base.kifu_show_handle(e)" :href="base.kifu_show_url(e)")

    b-menu-item.is_active_unset(icon="download" @click="sfx_play_click()")
      template(slot="label" slot-scope="props")
        | 棋譜ダウンロード
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        b-menu-item.is_active_unset(:label="e.name_with_turn(base.current_turn)" @click.prevent="base.kifu_download_handle(e)" :href="base.kifu_download_url(e)")
</template>

<script>
// これは特殊で ../Swars/SwarsBattleShow/SwarsBattleShowSidebar.vue のなかでも使っている
export default {
  name: "SbSidebarExport",
  props: {
    base: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
// @import "./sass/support.sass"
.SbSidebarExport
  __css_keep__: 0
</style>
