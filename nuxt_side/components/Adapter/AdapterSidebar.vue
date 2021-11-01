<template lang="pug">
b-sidebar.AdapterSidebar.is-unselectable(fullheight right v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(@click="base.share_board_open_handle" label="共有将棋盤に転送")
          b-menu-item.is_active_unset(@click="base.movie_factory_handle" label="動画作成" v-if="development_or_staging_p")
          b-menu-item.is_active_unset(@click="base.style_editor_open_handle" label="スタイルエディタに転送")

        b-menu-list(label="Export")
          b-menu-item.is_active_unset(@click="base.kifu_paper_handle" label="棋譜用紙 (PDF)")

          b-menu-item.is_active_unset(:expanded="false" @click="sound_play_click()")
            template(slot="label" slot-scope="props")
              | 表示
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              template(v-if="e.show")
                b-menu-item.is_active_unset(:label="e.name" @click.prevent="base.kifu_show_handle(e)" :href="base.kifu_show_url(e)")

          b-menu-item.is_active_unset(@click="sound_play_click()")
            template(slot="label" slot-scope="props")
              | コピー
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              template(v-if="e.clipboard")
                b-menu-item.is_active_unset(:label="e.name" @click="base.kifu_copy_handle(e)")

          b-menu-item.is_active_unset(@click="sound_play_click()")
            template(slot="label" slot-scope="props")
              | ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.FormatTypeInfo.values")
              b-menu-item.is_active_unset(:label="e.name" @click.prevent="base.kifu_download_handle(e)" :href="base.kifu_download_url(e)")

        b-menu-list(label="ANOTHER")
          b-menu-item.is_active_unset(label="対応フォーマットの確認" tag="nuxt-link" :to="{name: 'adapter-description'}" @click.native="sound_play_click()")
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
