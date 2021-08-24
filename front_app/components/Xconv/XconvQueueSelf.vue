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
      b-button.mb-0(@click="sound_play('click')" tag="a" :href="row.browser_path"            type="is-primary" icon-left="download"    :download="row.filename_human")
      b-button.mb-0(@click="sound_play('click')" tag="a" :href="row.browser_path"            type=""           icon-left="eye-outline" target="_blank"               )

      b-button.mb-0(@click="base.main_download_handle(row)"     type="is-light"   icon-left="download"            v-if="development_or_staging_p")
      b-button.mb-0(@click="base.load_handle(row)"              type="is-light"   icon-left="open-in-app"         v-if="development_or_staging_p")
      b-button.mb-0(@click="base.main_show_handle(row)"         type="is-light"   icon-left="eye-outline"         v-if="development_or_staging_p")
      b-button.mb-0(@click="base.secret_show_handle(row)"       type="is-light"   icon-left="link"                v-if="development_or_staging_p")
      b-button.mb-0(@click="base.probe_show_modal_handle(row)"  type="is-light"   icon-left="information-variant" v-if="development_or_staging_p")
      b-button.mb-0(@click="base.json_show_handle(row)"         type="is-light"   icon-left="code-json"           v-if="development_or_staging_p")

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
  // margin-top: 0rem
  td
    vertical-align: middle
</style>
