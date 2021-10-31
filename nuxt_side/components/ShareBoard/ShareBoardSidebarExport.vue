<template lang="pug">
.ShareBoardSidebarExport
  b-menu-list(label="いろんな種類で棋譜取得")
    b-menu-item.is_active_unset(icon="movie" label="動画作成" @click.native="base.video_new_handle" v-if="development_or_staging_p || true")

    b-menu-item.is_active_unset(icon="eye" :expanded="false" @click="sound_play_click()")
      template(slot="label" slot-scope="props")
        | 表示
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        template(v-if="e.show")
          b-menu-item.is_active_unset(:label="e.name_with_turn(base.turn_offset)" @click.prevent="base.kifu_show_handle(e)" :href="base.kifu_show_url(e)")

    b-menu-item.is_active_unset(icon="clipboard-plus-outline" @click="sound_play_click()")
      template(slot="label" slot-scope="props")
        | コピー
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        template(v-if="e.clipboard")
          b-menu-item.is_active_unset(:label="e.name_with_turn(base.turn_offset)" @click="base.kifu_copy_handle(e)")

    b-menu-item.is_active_unset(icon="download" @click="sound_play_click()")
      template(slot="label" slot-scope="props")
        | ダウンロード
        b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
      template(v-for="e in base.FormatTypeInfo.values")
        b-menu-item.is_active_unset(:label="e.name_with_turn(base.turn_offset)" @click.prevent="base.kifu_download_handle(e)" :href="base.kifu_download_url(e)")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardSidebarExport",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardSidebarExport
</style>
