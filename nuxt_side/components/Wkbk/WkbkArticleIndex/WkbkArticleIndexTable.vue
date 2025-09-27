<template lang="pug">
.WkbkArticleIndexTable
  //- .is-inline-block(
  b-table(
    :loading="base.$fetchState.pending"
    :data="base.articles || []"
    :mobile-cards="!base.detail_p"
    hoverable
    :narrowed="false"

    paginated
    backend-pagination
    pagination-simple

    :page="base.page"
    :total="base.total"
    :per-page="base.per"
    @page-change="base.page_change_handle"

    backend-sorting
    default-sort-direction="desc"
    :default-sort="[base.sort_column, base.sort_order]"
    @sort="base.sort_handle"

    detailed
    :show-detail-icon="false"
    detail-key="key"
    :opened-detailed="base.detailed_keys"
    )
    // ↓これを追加するとまとめて開いたときすべての音が鳴ってしまう
    // :has-detailed-visible="row => sfx_play_click()"

    b-table-column(v-slot="{row}" custom-key="key" field="key" :label="base.ArticleIndexColumnInfo.fetch('key').name" sortable :width="1" :visible="!!base.visible_hash.key") {{row.key}}

    b-table-column(v-slot="{row}" custom-key="title" field="title" :label="base.ArticleIndexColumnInfo.fetch('title').name" sortable :visible="true" cell-class="is_line_break_on")
      nuxt-link(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sfx_play_click()")
        | {{row.title || "(no title)"}}

    //- b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.ArticleIndexColumnInfo.fetch('user_id').name" sortable :visible="base.scope === 'everyone'")
    //-   WkbkUserName(:user="row.user")

    b-table-column(v-slot="{row}" custom-key="folder_key" field="folder.position" :label="base.ArticleIndexColumnInfo.fetch('folder_key').name" sortable :visible="!!base.visible_hash.folder_key")
      WkbkFolder(:folder_key="row.folder_key")

    b-table-column(v-slot="{row}" custom-key="lineage_key"         field="lineage.position"    :label="base.ArticleIndexColumnInfo.fetch('lineage_key').name" sortable :visible="!!base.visible_hash.lineage_key") {{row.lineage_key}}

    b-table-column(v-slot="{row}" custom-key="turn_max"            field="turn_max"            :label="base.ArticleIndexColumnInfo.fetch('turn_max').name"      sortable numeric :visible="!!base.visible_hash.turn_max")      {{row.turn_max}}

    b-table-column(v-slot="{row}" custom-key="difficulty" field="difficulty" :label="base.ArticleIndexColumnInfo.fetch('difficulty').name" sortable centered :visible="!!base.visible_hash.difficulty") {{row.difficulty}}

    b-table-column(v-slot="{row}" custom-key="tag_list"    field="tag_list"  :label="base.ArticleIndexColumnInfo.fetch('tag_list').name" :visible="!!base.visible_hash.tag_list")
      WkbkTagList(:tag_list="row.tag_list" :tag_search_handle="base.tag_search_handle")
      //- b-taglist
      //-   b-tag.is-clickable(v-for="tag in row.tag_list" :key="tag" rounded type="is-primary is-light" @click.native.prevent.stop="base.tag_search_handle(tag)") {{tag}}

    b-table-column(v-slot="{row}" custom-key="book_title" field="books.title" :label="base.ArticleIndexColumnInfo.fetch('book_title').name" sortable :visible="!!base.visible_hash.book_title")
      template(v-for="book in row.books")
        nuxt-link.is-block(:to="{name: 'rack-books-book_key', params: {book_key: book.key}}" @click.native="sfx_play_click()") {{book.title}}

    b-table-column(v-slot="{row}" custom-key="created_at"        field="created_at"        :label="base.ArticleIndexColumnInfo.fetch('created_at').name"       sortable         :visible="!!base.visible_hash.created_at")       {{$time.format_row(row.created_at)}}
    b-table-column(v-slot="{row}" custom-key="updated_at"        field="updated_at"        :label="base.ArticleIndexColumnInfo.fetch('updated_at').name"       sortable         :visible="!!base.visible_hash.updated_at")       {{$time.format_row(row.updated_at)}}

    b-table-column(v-slot="{row}" custom-key="operation" label="" :width="1" cell-class="operation_block")
      .buttons.is-centered.mb-0(v-if="g_current_user && g_current_user.id === row.user.id || development_p")
        nuxt-link.button.is-small.mb-0(:to="{name: 'rack-articles-article_key-edit', params: {article_key: row.key}}" @click.native="sfx_play_click()") 編集
        nuxt-link.button.is-small.mb-0(:to="{name: 'rack-articles-new', query: {source_article_key: row.key}}" @click.native="sfx_play_click()") コピーして新規

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
  // display: flex
  // justify-content: center
  // align-items: center

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

    // .tags
    //   flex-wrap: nowrap
    //   .tag
    //     height: auto // 行が上下が広がってしまうのを防ぐ

    // 複数並ぶ問題集の隙間
    // .book_title:not(:first-child)
    //   margin-left: 3rem

    .buttons
      flex-wrap: nowrap

  // モバイルでは CustomShogiPlayer を横幅最大にしたいので横のパディングを取る
  +mobile
    .detail
      td, .detail-container
        padding: 0
</style>
