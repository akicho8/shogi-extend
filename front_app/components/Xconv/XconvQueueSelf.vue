<template lang="pug">
b-table.XconvQueueSelf(
  v-if="base.my_records.length >= 1"
  :data="base.my_records"
  :mobile-cards="false"
  )
  b-table-column(v-slot="{row}" label="番号" numeric centered)
    //- template(v-if="base.xconv_record && base.xconv_record.id === row.id")
    //-   b-tag(rounded type="is-primary") {{row.id}}
    //- template(v-else)
    b-tag(rounded)
      | {{row.id}}
    //- b-table-column(v-slot="{row}" field="name" label="名前")
    //-   | {{row.user.name}}
  b-table-column(v-slot="{row}" field="status_info.name" label="状況" centered)
    b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
      | {{row.status_info.name}}
  b-table-column(v-slot="{row}")
    .is_line_break_on.has-text-danger.is-size-7(v-if="row.errored_at")
      | {{row.error_message}}
    .buttons.has-addons.are-small.mb-0(v-if="row.successed_at")
      b-button.mb-0(@click="base.main_download_handle(row)"     icon-left="download" type="is-primary")
      b-button.mb-0(@click="base.main_show_handle(row)"         icon-left="eye-outline")
      b-button.mb-0(@click="base.secret_show_handle(row)"       icon-left="link" v-if="development_or_staging_p")
      b-button.mb-0(@click="base.probe_show_modal_handle(row)"  icon-left="information-variant")
      b-button.mb-0(@click="base.json_show_handle(row)"         icon-left="code-json" v-if="development_p")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvQueueSelf",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvQueueSelf
  margin-top: 1.5rem
  td
    vertical-align: middle
</style>
