<template lang="pug">
.KiwiLemonNewQueueSelf.column.is-half
  .progress_container(v-if="base.progress_info && false")
    b-progress(type="is-danger" :value="base.progress_info.percent" show-value format="percent")

  b-table(
    v-if="$GX.present_p(base.my_records)"
    :data="base.my_records"
    :mobile-cards="false"
    :scrollable="true"
    )
    b-table-column(v-slot="{row}" label="番号" numeric centered :width="1")
      | {{row.id}}

    // "成功" が "変換中" になったときガクッとさせないための幅
    b-table-column(v-slot="{row}" field="status_info.name" label="状況" centered header-class="table_status_column")
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
        span.ml-1(v-if="false && base.progress_info && base.progress_info.id === row.id")
          | {{$GX.number_round_s(base.progress_info.percent, 2)}} %

    b-table-column(v-slot="{row}" field="successed_at" label="消費" centered :visible="development_p")
      | {{row.elapsed_human}}

    b-table-column(v-slot="{row}" label="表紙" cell-class="cover_text is-size-7 is_line_break_on")
      | {{$GX.str_truncate(row.all_params.media_builder_params.cover_text, {length: 80})}}

    b-table-column(v-slot="{row}")
      .is_line_break_on.has-text-danger.is-size-7(v-if="row.errored_at")
        | {{row.error_message}}
      .buttons.is-flex-wrap-nowrap.are-small.mb-0(v-if="row.successed_at")
        b-button.mb-0(@click="base.download_talk_handle" tag="a" :href="row.browser_path"  type="is-primary" icon-left="download"    :download="row.filename_human" title="ダウンロード")
        b-button.mb-0(@click="base.banana_new_handle(row)" icon-left="upload" :type="{'is-light': row.banana}" title="ライブラリ登録")

        b-button.mb-0(v-if="development_p" @click="base.retry_run_handle(row)"      icon-left="hammer")
        b-button.mb-0(v-if="development_p" @click="sfx_click()" tag="a" :href="row.browser_path"            type=""           icon-left="eye-outline" target="_blank")

        b-button.mb-0(v-if="development_p" @click="base.rails_attachment_show_handle(row)"     type="is-light"   icon-left="download"            )
        b-button.mb-0(v-if="development_p" @click="base.load_handle(row)"              type="is-light"   icon-left="open-in-app"         )
        b-button.mb-0(v-if="development_p" @click="base.rails_inline_show_test_handle(row)"         type="is-light"   icon-left="eye-outline"         )
        b-button.mb-0(v-if="development_p" @click="base.other_window_open_if_pc_handle(row)"       type="is-light"   icon-left="link"                )
        b-button.mb-0(v-if="development_p" @click="base.media_info_show_handle(row)"  type="is-light"   icon-left="information-variant" )
        b-button.mb-0(v-if="development_p" @click="base.json_show_handle(row)"         type="is-light"   icon-left="code-json"           )

        b-button.mb-0(@click="base.banana_show_handle(row)" icon-left="play" title="ライブラリを見る" v-if="row.banana")
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
  td
    vertical-align: middle
  .cover_text
    min-width: 8rem
</style>
