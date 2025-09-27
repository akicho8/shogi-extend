<template lang="pug">
.KiwiBananaIndexTable
  b-table(
    :loading="base.$fetchState.pending"
    :data="base.bananas || []"
    :mobile-cards="true"
    hoverable
    :narrowed="false"

    paginated
    backend-pagination
    pagination-simple

    :page="base.page" :total="base.total" :per-page="base.per"
    @page-change="base.page_change_handle"

    backend-sorting
    default-sort-direction="desc"
    :default-sort="[base.sort_column, base.sort_order]"
    @sort="base.sort_handle"
    )

    //- b-table-column(v-slot="{row}" custom-key="key" field="key" :label="base.BananaIndexColumnInfo.fetch('key').name" sortable :width="1")
    //-   | {{row.key}}

    b-table-column(v-slot="{row}" custom-key="title" field="title" :label="base.BananaIndexColumnInfo.fetch('title').name" sortable width="" cell-class="title_column")
      nuxt-link.is_line_break_on(:to="{name: 'video-watch-banana_key', params: {banana_key: row.key}}" @click.native="sfx_click()")
        | {{row.title}}
        //- .image.avatar_image.is-inline-block
        //-   img(:src="row.avatar_path" :alt="row.title")
        //- span.row_title
        //- | {{$gs.str_truncate(row.title, {length: s_config.TRUNCATE_MAX})}}
        //- | {{$gs.str_truncate(row.title, {length: s_config.TRUNCATE_MAX})}}

    //- b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.BananaIndexColumnInfo.fetch('user_id').name" sortable :visible="base.scope === 'everyone'")
    //-   nuxt-link(:to="{name: 'users-id', params: {id: row.user.id}}" @click.native="sfx_click()")
    //-     KiwiUserName(:user="row.user")

    b-table-column(v-slot="{row}" custom-key="access_logs_count" field="access_logs_count" :label="base.BananaIndexColumnInfo.fetch('access_logs_count').name" sortable numeric) {{row.access_logs_count}}
    b-table-column(v-slot="{row}" custom-key="banana_messages_count" field="banana_messages_count" :label="base.BananaIndexColumnInfo.fetch('banana_messages_count').name" sortable numeric) {{row.banana_messages_count}}

    b-table-column(v-slot="{row}" custom-key="folder_key" field="folder.position" :label="base.BananaIndexColumnInfo.fetch('folder_key').name" sortable)
      KiwiFolder(:folder_key="row.folder_key")

    b-table-column(v-slot="{row}" custom-key="created_at" field="created_at" :label="base.BananaIndexColumnInfo.fetch('created_at').name" sortable) {{$time.format_row(row.created_at)}}

    b-table-column(v-slot="{row}" custom-key="updated_at" field="updated_at" :label="base.BananaIndexColumnInfo.fetch('updated_at').name" sortable) {{$time.format_row(row.updated_at)}}

    b-table-column(v-slot="{row}" custom-key="operation" label="" width="1")
      //- nuxt-link(:to="{name: 'video-studio-banana_key-edit', params: {banana_key: row.key}}")
      //-   //- b-icon(icon="edit")
      //-   | 編集
      b-button(tag="nuxt-link" :to="{name: 'video-studio-banana_key-edit', params: {banana_key: row.key}}" size="is-small" @click.native="sfx_click()") 編集

      //- nuxt-link(:to="{name: 'video-articles-new', query: {banana_key: row.key}}" v-if="false")
      //-   b-icon(icon="plus")

      //- b-dropdown(append-to-body position="is-bottom-left" @active-change="sfx_click()")
      //-   b-dropdown-item(has-link)
      //-     nuxt-link(:to="{name: 'video-studio-banana_key-edit', params: {banana_key: row.key}}" @click.native="sfx_click()") 編集
      //-
      //-   a(slot="trigger")
      //-     b-icon(icon="dots-horizontal")
      //-
      //-   template(v-if="(g_current_user && g_current_user.id === row.user.id) || development_p")
      //-     b-dropdown-item(has-link)
      //-       nuxt-link(:to="{name: 'video-studio-banana_key-edit', params: {banana_key: row.key}}" @click.native="sfx_click()") 編集
      //-     //- b-dropdown-item(has-link)
      //-     //-   nuxt-link(:to="{name: 'video-articles-new', query: {banana_key: row.key}}"        @click.native="sfx_click()") 問題追加
      //-     //- b-dropdown-item(separator)
      //-     //- b-dropdown-item(has-link)
      //-     //-   a(@click="base.tweet_handle(row)") ツイート
      //-     //- b-dropdown-item.is-hidden-desktop(separator)
      //-     //- b-dropdown-item.is-hidden-desktop(has-link)
      //-     //-   a.delete キャンセル
      //-
      //-   //- this.tweet_window_popup({text: this.banana.tweet_body})

    template(slot="empty" v-if="base.bananas != null")
      section.section.is-unselectable
        .content.has-text-grey.has-text-centered
          p
            b-icon(icon="emoticon-sad" size="is-large")
          p
            | ひとつもありません
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "KiwiBananaIndexTable",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaIndexTable
  //- th, td
  //-   vertical-align: top

  th
    font-size: $size-7

  // td
  //   // details アイコンが大きすぎる対策
  //   &.chevron-cell
  //     width: 0
  //     padding-left: 0
  //     padding-right: 0
  //     .icon
  //       height: auto
  //       .mdi:before
  //         font-size: 12px ! important

    // .tags
    //   flex-wrap: nowrap
    //   .tag
    //     // 行が上下が広がってしまうのを防ぐ
    //     height: auto

  // モバイルでは CustomShogiPlayer を横幅最大にしたいので横のパディングを取る
  +mobile
    .detail
      td, .detail-container
        padding: 0

  // .avatar_image
  //   img
  //     max-height: none
  //     width:  calc(1200px * 0.15)
  //     height: calc( 630px * 0.15)
  //     border-radius: 6px

  // .row_title
  //   margin-left: 0.5rem
  //   vertical-align: top

  // .row_title
  //   max-width: 10rem
  .title_column
    +tablet
      max-width: 50%
</style>
