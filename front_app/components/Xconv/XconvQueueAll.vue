<template lang="pug">
.XconvQueueAll(v-if="base.xconv_info")
  nav.level.is-mobile
    .level-item.has-text-centered
      div
        p.heading 待ち
        p.title {{base.xconv_info.standby_only_count}}
    .level-item.has-text-centered(v-if="base.xconv_info.processing_only_count > 0 || true")
      div
        p.heading 変換中
        p.title {{base.xconv_info.processing_only_count}}
    .level-item.has-text-centered
      div
        p.heading 成功
        p.title {{base.xconv_info.success_only_count}}
    .level-item.has-text-centered(v-if="base.xconv_info.error_only_count > 0 || true")
      div
        p.heading 失敗
        p.title {{base.xconv_info.error_only_count}}
  b-table(
    v-if="base.xconv_info.xconv_records.length >= 1"
    :data="base.xconv_info.xconv_records"
    :mobile-cards="false"
    )
    //- :paginated="false"
    //- :per-page="10"
    b-table-column(v-slot="{row}" label="番号" numeric centered)
      template(v-if="row.user.id === g_current_user.id")
        b-tag(rounded) {{row.id}}
      template(v-else)
        b-tag(rounded type="is-white") {{row.id}}
    b-table-column(v-slot="{row}" field="name" label="名前")
      | {{string_truncate(row.user.name, {length: 10})}}
    b-table-column(v-slot="{row}" field="status_info.name" label="状況" centered)
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
      //- b-progress(type="is-primary" size="is-medium")
      //-   | {{row.status_info.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvQueueAll",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvQueueAll
  margin-top: 0rem
</style>
