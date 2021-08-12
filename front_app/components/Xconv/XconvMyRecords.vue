<template lang="pug">
.XconvMyRecords.columns(v-if="base.my_records.length >= 1")
  .column
    b-table(
      :data="base.my_records"
      :mobile-cards="false"
      :paginated="false"
      :per-page="10"
      )
      b-table-column(v-slot="{row}" label="予約ID" numeric)
        template(v-if="base.xconv_record && base.xconv_record.id === row.id")
          b-tag(rounded type="is-primary") {{row.id}}
        template(v-else)
          b-tag(rounded) {{row.id}}
      b-table-column(v-slot="{row}" field="name" label="名前")
        | {{row.user.name}}
      b-table-column(v-slot="{row}" field="status_info.name" label="状況")
        | {{row.status_info.name}}
        //- b-progress(type="is-primary" size="is-medium")
        //-   | {{row.status_info.name}}
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
