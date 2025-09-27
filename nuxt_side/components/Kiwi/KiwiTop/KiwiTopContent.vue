<template lang="pug">
.KiwiTopContent.columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
  .column.is-12
    .buttons.are-small.is_buttons_scroll
      template(v-for="e in base.SearchPresetInfo.values")
        b-button(v-if="e.showable_p(g_current_user)" @click="base.search_preset_handle(e)" :type="{'is-primary': base.search_preset_info.key === e.key}")
          | {{e.name}}

  KiwiTopTagList(:base="base")

  .column.is-4-tablet.is-3-desktop.is-2-widescreen(v-for="e in base.bananas")
    nuxt-link.card.is-clickable(tag="div" :to="{name: 'video-watch-banana_key', params: {banana_key: e.key}}" @click.native="sfx_play_click()")
      .card-image
        template(v-if="e.lemon.thumbnail_browser_path")
          .image.is-16by9
            img(:src="e.lemon_thumbnail_browser_path_with_pos")
        template(v-else-if="e.lemon.content_type && e.lemon.content_type.startsWith('image')")
          .image.is-16by9
            img(:src="e.lemon.browser_path")
        template(v-else-if="e.lemon.content_type === 'application/zip'")
          b-icon(icon="zip-box-outline" size="is-large")
        template(v-else)
          template(v-if="development_p && false")
            p コンテンツ不明
            p e.lemon.content_type: {{e.lemon.content_type}}
            p browser_path: {{e.lemon.browser_path}}
      .card-content
        KiwiBananaInfo(:base="base" :banana="e" :key="e.key")

  .column.is-12(v-if="base.xpage_info")
    //- テーブルのページネーションに合わせとく
    .level
      .level-left
        .level-item
      .level-right
        .level-item
          b-pagination(
            :total="base.xpage_info.total_count"
            :per-page="base.xpage_info.limit_value"
            :current="base.xpage_info.current_page"
            @change="base.page_change_handle"
            order="is-right"
            simple
            )
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "KiwiTopContent",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"

.KiwiTopContent
  .card-content
    padding: 1rem
</style>
