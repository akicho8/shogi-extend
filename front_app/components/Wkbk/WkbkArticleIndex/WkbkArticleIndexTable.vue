<template lang="pug">
b-table.WkbkArticleIndexTable(
  :loading="base.$fetchState.pending"
  :data="base.articles || []"
  :mobile-cards="false"
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

  detailed
  :show-detail-icon="false"
  detail-key="id2"
  :opened-detailed="base.detailed_keys"
  )
  // ↓これを追加するとまとめて開いたときすべての音が鳴ってしまう
  // :has-detailed-visible="row => sound_play('click')"

  b-table-column(v-slot="{row}" custom-key="key" field="key" :label="base.ArticleIndexColumnInfo.fetch('key').name" sortable numeric wkeyth="1" :visible="!!base.visible_hash.key") {{row.key}}

  b-table-column(v-slot="{row}" custom-key="title" field="title" :label="base.ArticleIndexColumnInfo.fetch('title').name" sortable :visible="!!base.visible_hash.title")
    nuxt-link(:to="{name: 'library-articles-article_key', params: {article_key: row.key2}}" @click.native="sound_play('click')")
      | {{string_truncate(row.title, {length: s_config.TRUNCATE_MAX})}}

  b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.ArticleIndexColumnInfo.fetch('user_id').name" sortable :visible="base.scope === 'everyone'")
    WkbkUserName(:user="row.user")

  b-table-column(v-slot="{row}" custom-key="book_title" field="book.title" :label="base.ArticleIndexColumnInfo.fetch('book_title').name" sortable :visible="!!base.visible_hash.book_title")
    nuxt-link(:to="{name: 'library-books-book_key', params: {book_key: row.book.key}}" v-if="row.book")

      | {{string_truncate(row.book.title, {length: s_config.TRUNCATE_MAX})}}
      span(v-if="false") ({{row.book.articles_count}})

  b-table-column(v-slot="{row}" custom-key="lineage_key"         field="lineage.position"    :label="base.ArticleIndexColumnInfo.fetch('lineage_key').name" sortable :visible="!!base.visible_hash.lineage_key") {{row.lineage_key}}

  b-table-column(v-slot="{row}" custom-key="turn_max"            field="turn_max"            :label="base.ArticleIndexColumnInfo.fetch('turn_max').name"      sortable numeric :visible="!!base.visible_hash.turn_max")      {{row.turn_max}}

  b-table-column(v-slot="{row}" custom-key="difficulty" field="difficulty" :label="base.ArticleIndexColumnInfo.fetch('difficulty').name" sortable :visible="!!base.visible_hash.difficulty") {{row.difficulty}}

  b-table-column(v-slot="{row}" custom-key="owner_tag_list"    field="owner_tag_list"  :label="base.ArticleIndexColumnInfo.fetch('owner_tag_list').name" :visible="!!base.visible_hash.owner_tag_list")
    //- b-taglist
    b-tag.is-clickable.mr-1(v-for="tag in row.owner_tag_list" @click.native.stop="base.tag_search_handle(tag)" rounded)
      | {{tag}}

  b-table-column(v-slot="{row}" custom-key="created_at"        field="created_at"        :label="base.ArticleIndexColumnInfo.fetch('created_at').name"       sortable         :visible="!!base.visible_hash.created_at")       {{row_time_format(row.created_at)}}
  b-table-column(v-slot="{row}" custom-key="updated_at"        field="updated_at"        :label="base.ArticleIndexColumnInfo.fetch('updated_at').name"       sortable         :visible="!!base.visible_hash.updated_at")       {{row_time_format(row.updated_at)}}

  b-table-column(v-slot="{row}" custom-key="operation" label="" width="1")
    template(v-if="g_current_user && g_current_user.id === row.user.id || development_p")
      nuxt-link(:to="{name: 'library-articles-article_key-edit', params: {article_key: row.key2}}" @click.native="sound_play('click')") 編集

  template(slot="empty" v-if="base.articles != null")
    section.section.is-unselectable
      .content.has-text-grey.has-text-centered
        p
          b-icon(icon="emoticon-sad" size="is-large")
        p
          | ひとつもありません

  template(slot="detail" slot-scope="props")
    WkbkArticleIndexDetail(:article="props.row")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkArticleIndexTable",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexTable
  th, td
    vertical-align: middle

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
