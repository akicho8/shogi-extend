<template lang="pug">
b-table.WkbkBookIndexTable.mx-2.mt-0(
  v-if="base.books"
  :data="base.books"
  :mobile-cards="false"
  hoverable
  :narrowed="false"

  paginated
  backend-pagination
  pagination-simple
  :page="base.page_info.page"
  :total="base.page_info.total"
  :per-page="base.page_info.per"
  @page-change="base.page_change_handle"

  backend-sorting
  :default-sort-direction="base.page_info.sort_order_default"
  :default-sort="[base.page_info.sort_column, base.page_info.sort_order]"
  @sort="base.sort_handle"

  )
  //- detailed
  //- detail-key="id"
  //- :opened-detailed="base.detailed_ids"

  //- :has-detailed-visible="row => sound_play('click')"

  //- b-table-column(v-slot="{row}" custom-key="id"                field="id"                :label="base.BookIndexColumnInfo.fetch('id').short_name"               sortable numeric :visible="!!base.visible_hash.id") {{row.id}}
  //- b-table-column(v-slot="{row}" custom-key="user_id"           field="user.id"           :label="base.BookIndexColumnInfo.fetch('user_id').short_name"       sortable         :visible="!!base.visible_hash.user_id") {{row.user.name}}

  b-table-column(v-slot="{row}" custom-key="title" field="title" :label="base.BookIndexColumnInfo.fetch('title').short_name" sortable)
    nuxt-link(:to="{name: 'wkbk-books-book_id', params: {book_id: row.id}}" @click.native="sound_play('click')")
      | {{string_truncate(row.title, {length: 20})}}({{row.articles_count}})

  b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.BookIndexColumnInfo.fetch('user_id').short_name" sortable :visible="base.current_tab.key === 'everyone'")
    nuxt-link(:to="{name: 'users-id', params: {id: row.user.id}}" @click.native="sound_play('click')")
      | {{string_truncate(row.user.name, {length: 20})}}

  //- b-table-column(v-slot="{row}" custom-key="articles_count" field="articles_count" :label="base.BookIndexColumnInfo.fetch('articles_count').short_name" sortable numeric :visible="!!base.visible_hash.articles_count") {{row.articles_count}}

  //- b-table-column(v-slot="{row}" custom-key="owner_tag_list"    field="owner_tag_list"  :label="base.BookIndexColumnInfo.fetch('owner_tag_list').short_name" :visible="!!base.visible_hash.owner_tag_list")
  //-   b-taglist
  //-     b-tag.is-clickable(v-for="tag in row.owner_tag_list" @click.native.stop="tag_search_handle(tag)" rounded)
  //-       | {{tag}}

  //- b-table-column(v-slot="{row}" custom-key="created_at"        field="created_at"        :label="base.BookIndexColumnInfo.fetch('created_at').short_name"       sortable         :visible="!!base.visible_hash.created_at")       {{row_time_format(row.created_at)}}
  //- b-table-column(v-slot="{row}" custom-key="updated_at"        field="updated_at"        :label="base.BookIndexColumnInfo.fetch('updated_at').short_name"       sortable         :visible="!!base.visible_hash.updated_at")       {{row_time_format(row.updated_at)}}

  b-table-column(v-slot="{row}" custom-key="operation" label="")
    template(v-if="g_current_user && g_current_user.id === row.user.id || debug_force_edit_p")
      //- nuxt-link(:to="{name: 'wkbk-books-book_id-edit', params: {book_id: row.id}}")
      //-   b-icon(icon="edit")
      //-   | 編集
      nuxt-link(:to="{name: 'wkbk-articles-new', query: {book_id: row.id}}")
        b-icon(icon="plus")

      b-dropdown(append-to-body position="is-top-left" @active-change="sound_play('click')")
        a.px-4(slot="trigger")
          b-icon(icon="dots-vertical")
        b-dropdown-item(has-link )
          nuxt-link(:to="{name: 'wkbk-books-book_id-edit', params: {book_id: row.id}}" @click.native="sound_play('click')") 編集
        //- b-dropdown-item(:separator="true")

  template(slot="empty")
    section.section.is-unselectable
      .content.has-text-grey.has-text-centered
        p
          b-icon(icon="emoticon-sad" size="is-large")
        p
          | ひとつもありません

  template(slot="detail" slot-scope="props")
    WkbkBookIndexDetail(:book="props.row")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkBookIndexTable",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexTable
  th
    font-size: $size-7

  td
    // details アイコンが大きすぎる対策
    &.chevron-cell
      width: 0
      padding-left: 0
      padding-right: 0
      .icon
        height: auto
        .mdi:before
          font-size: 12px ! important

    .tags
      flex-wrap: nowrap
      .tag
        // 行が上下が広がってしまうのを防ぐ
        height: auto

  // モバイルでは CustomShogiPlayer を横幅最大にしたいので横のパディングを取る
  +mobile
    .detail
      td, .detail-container
        padding: 0
</style>
