<template lang="pug">
.KiwiLemonNewAdmin.column.is-12(v-if="base.admin_info")
  .title.is-6 管理用

  nav.level.is-mobile
    .level-item.has-text-centered
      .buttons.is-flex-wrap-nowrap.mb-0
        b-button.mb-0(@click="base.all_info_reload_handle") リロード
        b-button.mb-0(@click="base.zombie_kill_now_handle") ゾンビ抹殺
        b-button.mb-0(@click="base.background_job_kick_handle") ジョブ実行(時間外可)
    .level-item.has-text-centered
      div
        .heading 待ち
        .title {{base.admin_info.sidekiq_queue_count}}
    .level-item.has-text-centered
      div
        .heading 実行中
        .title {{base.admin_info.sidekiq_run_count}}

  b-table(
    v-if="$GX.present_p(base.admin_info.lemons)"
    :data="base.admin_info.lemons"
    :mobile-cards="false"
    :scrollable="true"
    )

    b-table-column(v-slot="{row}" field="id" label="ID" numeric centered sortable :width="1")
      | {{row.id}}

    b-table-column(v-slot="{row}" field="user.id" label="所有者" sortable :width="1")
      | {{row.user?.name}}

    // "成功" が "変換中" になったときガクッとさせないための幅
    b-table-column(v-slot="{row}" field="status_info.name" label="状況" centered sortable header-class="table_status_column")
      b-tag(rounded :type="row.status_info.type" :class="row.status_info.class")
        | {{row.status_info.name}}
        span.ml-1(v-if="base.progress_info && base.progress_info.id === row.id")
          | {{$GX.number_round_s(base.progress_info.percent, 2)}} %

    b-table-column(v-slot="{row}" field="successed_at" label="消費" centered sortable :width="1")
      | {{row.elapsed_human}}

    b-table-column(v-slot="{row}" field="all_params.media_builder_params.recipe_key" label="種類" centered sortable :width="1")
      | {{row.recipe_info.name}}

    b-table-column(v-slot="{row}" field="created_at" label="登録" sortable)
      | {{$time.format_row(row.created_at)}}

    b-table-column(v-slot="{row}" field="processed_at" label="終了" sortable)
      | {{$time.format_row(row.process_end_at)}}

    b-table-column(v-slot="{row}" field="errored_at" label="エラー" sortable)
      .is_line_break_on.has-text-danger.is-size-7(v-if="row.errored_at")
        | {{row.error_message}}

    b-table-column(v-slot="{row}" label="表紙" cell-class="cover_text is-size-7 is_line_break_on")
      | {{$GX.str_truncate(row.all_params.media_builder_params.cover_text, {length: 80})}}

    b-table-column(v-slot="{row}" label="操作")
      .buttons.is-flex-wrap-nowrap.are-small.mb-0
        b-button.mb-0(@click="base.download_talk_handle" tag="a" :href="row.browser_path" type="is-primary" icon-left="download"    :download="row.filename_human" title="ダウンロード")
        b-button.mb-0(@click="base.banana_new_handle(row)" icon-left="upload" :type="{'is-light': row.banana}"  title="ライブラリ登録")
        b-button.mb-0(@click="base.retry_run_handle(row)"      type="is-info" icon-left="hammer" title="リトライ")
        b-button.mb-0(@click="sfx_click()"                                         type="" tag="a" :href="row.browser_path" icon-left="eye-outline" target="_blank" title="ダウンロードリンクをダウンロードせずに開く")
        b-button.mb-0(@click="base.rails_attachment_show_handle(row)"                     type="is-light"   icon-left="download"                                           title="Rails側のコントローラ経由でダウンロードするテスト")
        b-button.mb-0(@click="base.load_handle(row)"                                    type="is-light"   icon-left="open-in-app"                                        title="プレビューのレコードにコピー")
        b-button.mb-0(@click="base.rails_inline_show_test_handle(row)"                    type="is-light"   icon-left="eye-outline"                                        title="Rails側のコントローラ経由でインライン表示するテスト")
        b-button.mb-0(@click="base.other_window_open_if_pc_handle(row)"                 type="is-light"   icon-left="link"                                               title="モバイルならそのままでPCなら別ウィンドウで開く")
        b-button.mb-0(@click="base.media_info_show_handle(row)"                           type="is-light"   icon-left="information-variant"                                title="変換後のファイル情報を表示")
        b-button.mb-0(@click="base.json_show_handle(row)"                                 type="is-light"   icon-left="code-json"                                          title="JSON確認")
        b-button.mb-0(@click="base.destroy_run_handle(row)"    type="is-danger" icon-left="trash-can-outline" title="削除" v-if="row.errored_at || true")
        b-button.mb-0(@click="base.banana_show_handle(row)" icon-left="play" title="ライブラリを見る" v-if="row.banana")

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewAdmin",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewAdmin
  td
    vertical-align: middle
  .cover_text
    min-width: 8rem
</style>
