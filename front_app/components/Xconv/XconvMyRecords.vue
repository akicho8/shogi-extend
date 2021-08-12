<template lang="pug">
.XconvMyRecords.column(v-if="base.my_records.length >= 1")
  b-table(
    :data="base.my_records"
    :mobile-cards="false"
    )
    b-table-column(v-slot="{row}" label="予約ID" numeric)
      //- template(v-if="base.xconv_record && base.xconv_record.id === row.id")
      //-   b-tag(rounded type="is-primary") {{row.id}}
      //- template(v-else)
      b-tag(rounded) {{row.id}}
      //- b-table-column(v-slot="{row}" field="name" label="名前")
      //-   | {{row.user.name}}
    b-table-column(v-slot="{row}" field="status_info.name" label="状況")
      | {{row.status_info.name}}
    b-table-column(v-slot="{row}")
      template(v-if="row.successed_at")
        .buttons.are-small.mb-0
          b-button.mb-0(@click="base.send_file_handle(row, 'attachment')" type="is-primary" icon-left="download")
          b-button.mb-0(@click="base.send_file_handle(row, 'inline')"                       icon-left="eye")
          b-button.mb-0(@click="base.direct_link_handle(row)"                              icon-left="link")
          b-button.mb-0(@click="base.other_window_open_handle(row)"                        icon-left="open-in-new")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvMyRecords",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvMyRecords
  margin-top: 1.5rem
</style>
