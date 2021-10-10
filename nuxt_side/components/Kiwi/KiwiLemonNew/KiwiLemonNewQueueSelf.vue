<template lang="pug">
.KiwiLemonNewQueueSelf
  .progress_container(v-if="base.progress_info && false")
    b-progress(type="is-danger" :value="base.progress_info.percent" show-value format="percent")

  b-table(
    v-if="base.my_records.length >= 1"
    :data="base.my_records"
    :mobile-cards="false"
    )
    b-table-column(v-slot="{row}" label="番号" numeric centered :width="1")
      //- template(v-if="base.lemon && base.lemon.id === row.id")
      //-   b-tag(rounded type="is-primary") {{row.id}}
      //- template(v-else)
      //- b-tag(rounded)
      //-   | {{row.id}}
      | {{row.id}}
      //- b-table-column(v-slot="{row}" field="name" label="名前")
      //-   | {{row.user.name}}

    // "成功" が "変換中" になったときガクッとさせないための幅
    b-table-column(v-slot="{row}" field="status_info.name" label="状況" centered header-class="table_status_column")
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
        span.ml-1(v-if="false && base.progress_info && base.progress_info.id === row.id")
          | {{number_round(base.progress_info.percent, 2)}} %

    b-table-column(v-slot="{row}" field="successed_at" label="消費" centered :width="1" :visible="development_or_staging_p")
      | {{row.elapsed_human}}
    b-table-column(v-slot="{row}")
      .is_line_break_on.has-text-danger.is-size-7(v-if="row.errored_at")
        | {{row.error_message}}
      .buttons.has-addons.are-small.mb-0(v-if="row.successed_at")
        b-button.mb-0(@click="base.download_handle" tag="a" :href="row.browser_path"            type="is-primary" icon-left="download"    :download="row.filename_human")
        b-button.mb-0(@click="base.banana_new_handle(row)" icon-left="upload")

        b-button.mb-0(v-if="development_or_staging_p" @click="sound_play('click')" tag="a" :href="row.browser_path"            type=""           icon-left="eye-outline" target="_blank")
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__main_download_handle(row)"     type="is-light"   icon-left="download"            )
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__load_handle(row)"              type="is-light"   icon-left="open-in-app"         )
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__main_show_handle(row)"         type="is-light"   icon-left="eye-outline"         )
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__secret_show_handle(row)"       type="is-light"   icon-left="link"                )
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__probe_show_modal_handle(row)"  type="is-light"   icon-left="information-variant" )
        b-button.mb-0(v-if="development_or_staging_p" @click="base.__json_show_handle(row)"         type="is-light"   icon-left="code-json"           )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewQueueSelf",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewQueueSelf
  // margin-top: 0rem
  td
    vertical-align: middle
</style>
