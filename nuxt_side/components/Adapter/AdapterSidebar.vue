<template lang="pug">
b-sidebar.AdapterSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(@click="base.share_board_first_open_handle" :label="`共有将棋盤 #${0}`")
          b-menu-item.is_active_unset(@click="base.share_board_last_open_handle"  :label="`共有将棋盤 #${base.fixed_turn}`" v-if="base.fixed_turn > 0")
          b-menu-item.is_active_unset(@click="base.video_new_open_handle" label="動画作成")
          b-menu-item.is_active_unset(@click="base.style_editor_open_handle" label="ｽﾀｲﾙｴﾃﾞｨﾀに転送")

        b-menu-list(label="Export")
          b-menu-item.is_active_unset(@click="base.print_open_handle" label="棋譜用紙 (PDF)")

          b-menu-item.is_active_unset(:expanded="false" @click="sfx_play_click()")
            template(slot="label" slot-scope="props")
              | 表示
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              template(v-if="e.show")
                b-menu-item.is_active_unset(:label="e.name" @click.prevent="base.kifu_show_handle_of(e)" :href="base.kifu_show_url_of(e)")

          b-menu-item.is_active_unset(@click="sfx_play_click()")
            template(slot="label" slot-scope="props")
              | コピー
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              template(v-if="e.clipboard")
                b-menu-item.is_active_unset(:label="e.name" @click="base.kifu_copy_handle(e)")

          b-menu-item.is_active_unset(@click="sfx_play_click()")
            template(slot="label" slot-scope="props")
              | ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              b-menu-item.is_active_unset(:label="e.name" @click.prevent="base.kifu_dl_handle_of(e)" :href="base.kifu_dl_url_of(e)")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(label="ブックマークレット" tag="nuxt-link" :to="{name: 'adapter-bookmarklet'}" @click.native="sfx_play_click()")
          b-menu-item.is_active_unset(label="対応形式確認" tag="nuxt-link" :to="{name: 'adapter-format'}" @click.native="sfx_play_click()")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "AdapterSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
.AdapterSidebar
  .sidebar-content
    // width: unset
    // a
    //   white-space: nowrap
    .menu-label:not(:first-child)
      margin-top: 2em
</style>
