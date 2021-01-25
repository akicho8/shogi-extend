<template lang="pug">
b-table.WkbkArticleIndexTable.mx-2.mt-0(
  v-if="base.articles"
  :loading="base.$fetchState.pending"
  :data="base.articles"
  :mobile-cards="false"
  hoverable
  :narrowed="false"

  paginated
  backend-pagination
  pagination-simple

  :page="base.page" :total="base.total" :per-page="base.per"
  @page-change="base.page_change_handle"

  backend-sorting
  default-sort-direction="asc"
  :default-sort="[base.sort_column, base.sort_order]"
  @sort="base.sort_handle"

  detailed
  detail-key="id"
  :opened-detailed="base.detailed_ids"
  )
  //- :has-detailed-visible="row => sound_play('click')"

  b-table-column(v-slot="{row}" custom-key="id"                field="id"                :label="base.ArticleIndexColumnInfo.fetch('id').short_name"               sortable numeric :visible="!!base.visible_hash.id") {{row.id}}

  //- b-table-column(v-slot="{row}" custom-key="source_author"     field="source_author"     :label="base.ArticleIndexColumnInfo.fetch('source_author').short_name"       sortable         :visible="!!base.visible_hash.source_author")
  //-   template(v-if="row.source_about_key === 'unknown'")
  //-     | 不詳
  //-   template(v-else-if="row.source_author")
  //-     span.has-text-weight-bold
  //-       template(v-if="row.source_media_url")
  //-         a(:href="row.source_media_url" target="_blank")
  //-           | {{row.source_author}}
  //-           b-icon(icon="link" size="is-small")
  //-       template(v-else)
  //-         | {{row.source_author}}
  //-   template(v-else)
  //-     a {{row.user.name}}

  b-table-column(v-slot="{row}" custom-key="title" field="title" :label="base.ArticleIndexColumnInfo.fetch('title').short_name" sortable :visible="!!base.visible_hash.title")
    nuxt-link(:to="{name: 'library-articles-article_id-edit', params: {article_id: row.id}}")
      | {{string_truncate(row.title, {length: 20})}}

  b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.ArticleIndexColumnInfo.fetch('user_id').short_name" sortable :visible="base.scope === 'everyone'")
    nuxt-link(:to="{name: 'users-id', params: {id: row.user.id}}")
      | {{string_truncate(row.user.name, {length: 20})}}

  b-table-column(v-slot="{row}" custom-key="book_title" field="book_title" :label="base.ArticleIndexColumnInfo.fetch('book_title').short_name" sortable :visible="!!base.visible_hash.book_title")
    nuxt-link(:to="{name: 'library-books-book_id-edit', params: {book_id: row.book.id}}" v-if="row.book")
      | {{string_truncate(row.book.title, {length: 20})}}({{row.book.articles_count}})

  //- b-table-column(v-slot="{row}" custom-key="histories_count"   field="histories_count"   :label="base.ArticleIndexColumnInfo.fetch('histories_count').short_name"  sortable numeric :visible="!!base.visible_hash.histories_count")  {{row.histories_count}}
  //- b-table-column(v-slot="{row}" custom-key="ox_record.o_rate"  field="ox_record.o_rate"  :label="base.ArticleIndexColumnInfo.fetch('o_rate').short_name"  sortable numeric :visible="!!base.visible_hash.o_rate")  {{float_to_perc(row.ox_record.o_rate)}} %
  //- b-table-column(v-slot="{row}" custom-key="ox_record.o_count" field="ox_record.o_count" :label="base.ArticleIndexColumnInfo.fetch('o_count').short_name" sortable numeric :visible="!!base.visible_hash.o_count") {{row.ox_record.o_count}}
  //- b-table-column(v-slot="{row}" custom-key="ox_record.x_count" field="ox_record.x_count" :label="base.ArticleIndexColumnInfo.fetch('x_count').short_name" sortable numeric :visible="!!base.visible_hash.x_count") {{row.ox_record.x_count}}
  //- b-table-column(v-slot="{row}" custom-key="messages_count"    field="messages_count"  :label="base.ArticleIndexColumnInfo.fetch('messages_count').short_name"      sortable numeric :visible="!!base.visible_hash.messages_count")      {{row.messages_count}}

  //- b-table-column(v-slot="{row}" custom-key="good_rate"         field="good_rate"         :label="base.ArticleIndexColumnInfo.fetch('good_rate').short_name"        sortable numeric :visible="!!base.visible_hash.good_rate") {{float_to_perc(row.good_rate)}} %
  //- b-table-column(v-slot="{row}" custom-key="good_marks_count"  field="good_marks_count"  :label="base.ArticleIndexColumnInfo.fetch('good_marks_count').short_name" sortable numeric :visible="!!base.visible_hash.good_marks_count") {{row.good_marks_count}}
  //- b-table-column(v-slot="{row}" custom-key="bad_marks_count"   field="bad_marks_count"   :label="base.ArticleIndexColumnInfo.fetch('bad_marks_count').short_name"  sortable numeric :visible="!!base.visible_hash.bad_marks_count")  {{row.bad_marks_count}}

  //- b-table-column(v-slot="{row}" custom-key="clip_marks_count"  field="clip_marks_count"  :label="base.ArticleIndexColumnInfo.fetch('clip_marks_count').short_name"      sortable numeric :visible="!!base.visible_hash.clip_marks_count")      {{row.clip_marks_count}}

  b-table-column(v-slot="{row}" custom-key="difficulty_level"  field="difficulty_level"  :label="base.ArticleIndexColumnInfo.fetch('difficulty_level').short_name" sortable numeric :visible="!!base.visible_hash.difficulty_level") {{row.difficulty_level}}
  //- b-table-column(v-slot="{row}" custom-key="time_limit_sec"    field="time_limit_sec"  :label="base.ArticleIndexColumnInfo.fetch('time_limit_sec').short_name" sortable numeric :visible="!!base.visible_hash.time_limit_sec") {{row.time_limit_sec}}秒

  b-table-column(v-slot="{row}" custom-key="lineage_key"         field="lineage_key"         :label="base.ArticleIndexColumnInfo.fetch('lineage_key').short_name" sortable :visible="!!base.visible_hash.lineage_key") {{row.lineage_key}}
  b-table-column(v-slot="{row}" custom-key="turn_max"            field="turn_max"            :label="base.ArticleIndexColumnInfo.fetch('turn_max').short_name"      sortable numeric :visible="!!base.visible_hash.turn_max")      {{row.turn_max}}
  b-table-column(v-slot="{row}" custom-key="moves_answers_count" field="moves_answers_count" :label="base.ArticleIndexColumnInfo.fetch('moves_answers_count').short_name" sortable numeric :visible="!!base.visible_hash.moves_answers_count") {{row.moves_answers_count}}

  b-table-column(v-slot="{row}" custom-key="owner_tag_list"    field="owner_tag_list"  :label="base.ArticleIndexColumnInfo.fetch('owner_tag_list').short_name" :visible="!!base.visible_hash.owner_tag_list")
    b-taglist
      b-tag.is-clickable(v-for="tag in row.owner_tag_list" @click.native.stop="base.tag_search_handle(tag)" rounded)
        | {{tag}}

  b-table-column(v-slot="{row}" custom-key="created_at"        field="created_at"        :label="base.ArticleIndexColumnInfo.fetch('created_at').short_name"       sortable         :visible="!!base.visible_hash.created_at")       {{row_time_format(row.created_at)}}
  b-table-column(v-slot="{row}" custom-key="updated_at"        field="updated_at"        :label="base.ArticleIndexColumnInfo.fetch('updated_at').short_name"       sortable         :visible="!!base.visible_hash.updated_at")       {{row_time_format(row.updated_at)}}

  b-table-column(v-slot="{row}" custom-key="operation" label="操作")
    template(v-if="g_current_user && g_current_user.id === row.user.id || debug_force_edit_p")
      nuxt-link(:to="{name: 'library-articles-article_id-edit', params: {article_id: row.id}}") 編集

  template(slot="empty")
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
