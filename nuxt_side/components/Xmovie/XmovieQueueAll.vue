<template lang="pug">
.XmovieQueueAll(v-if="base.xmovie_info")
  nav.level.is-mobile
    .level-item.has-text-centered
      div
        p.heading 待ち
        p.title {{base.xmovie_info.standby_only_count}}
    .level-item.has-text-centered(v-if="base.xmovie_info.processing_only_count > 0 || true")
      div
        p.heading 変換中
        p.title {{base.xmovie_info.processing_only_count}}
    .level-item.has-text-centered
      div
        p.heading 成功
        p.title {{base.xmovie_info.success_only_count}}
    .level-item.has-text-centered(v-if="base.xmovie_info.error_only_count > 0 || true")
      div
        p.heading 失敗
        p.title {{base.xmovie_info.error_only_count}}
  b-table(
    v-if="base.xmovie_info.xmovie_records.length >= 1"
    :data="base.xmovie_info.xmovie_records"
    :mobile-cards="false"
    )
    //- :paginated="false"
    //- :per-page="10"
    b-table-column(v-slot="{row}" label="番号" numeric centered)
      b-tag(rounded :class="{'has-text-weight-bold': row.user.id === g_current_user.id}") {{row.id}}
    b-table-column(v-slot="{row}" field="name" label="名前")
      | {{string_truncate(row.user.name, {length: 10})}}
    b-table-column(v-slot="{row}" field="status_key" label="状況" centered)
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
      //- b-progress(type="is-primary" size="is-medium")
      //-   | {{row.status_info.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieQueueAll",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieQueueAll
  margin-top: 0rem
  td
    vertical-align: middle
</style>
