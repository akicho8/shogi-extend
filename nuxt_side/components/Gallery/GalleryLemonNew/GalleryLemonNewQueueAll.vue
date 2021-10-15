<template lang="pug">
.GalleryLemonNewQueueAll(v-if="base.gallery_info")
  nav.level.is-mobile
    .level-item.has-text-centered
      div
        p.heading 待ち
        p.title {{base.gallery_info.standby_only_count}}
    .level-item.has-text-centered(v-if="base.gallery_info.processing_only_count > 0 || true")
      div
        p.heading 変換中
        p.title {{base.gallery_info.processing_only_count}}
    .level-item.has-text-centered
      div
        p.heading 成功
        p.title {{base.gallery_info.success_only_count}}
    .level-item.has-text-centered(v-if="base.gallery_info.error_only_count > 0 || true")
      div
        p.heading 失敗
        p.title {{base.gallery_info.error_only_count}}
  b-table(
    v-if="base.gallery_info.lemons.length >= 1"
    :data="base.gallery_info.lemons"
    :mobile-cards="false"
    )
    b-table-column(v-slot="{row}" label="番号" numeric centered :width="1")
      span(:class="{'has-text-weight-bold': row.user.id === g_current_user.id}") {{row.id}}
    b-table-column(v-slot="{row}" field="status_key" label="状況" centered header-class="table_status_column")
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
    b-table-column(v-slot="{row}" field="name" label="所有者")
      | {{string_truncate(row.user.name, {length: 10})}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryLemonNewQueueAll",
  mixins: [support_child],
}
</script>

<style lang="sass">
.GalleryLemonNewQueueAll
  margin-top: 0rem
  td
    vertical-align: middle
</style>
