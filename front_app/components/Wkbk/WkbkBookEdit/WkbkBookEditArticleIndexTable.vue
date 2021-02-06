<template lang="pug">
.WkbkBookEditArticleIndexTable
  .box
    .title.is-6 問題の並び替え
    .subtitle.is-7.mb-0 出題順序で「カスタマイズ」を選択したときに有効 (DnD)
    b-table.mt-1(
      :data="base.book.articles"
      :mobile-cards="false"
      :show-header="true"
      hoverable
      narrowed

      :row-class="() => 'is-clickable'"
      draggable
      @dragstart="dragstart_handle"
      @drop="drop_handle"
      @dragover="dragover_handle"
      @dragleave="dragleave_handle"
      )
      //- :loading="base.$fetchState.pending"

      //- paginated
      //- backend-pagination
      //- pagination-simple
      //-
      //- :page="base.page" :total="base.total" :per-page="base.per"
      //- @page-change="base.page_change_handle"
      //-
      //- backend-sorting
      //- default-sort-direction="desc"
      //- :default-sort="[base.sort_column, base.sort_order]"
      //- @sort="base.sort_handle"
      //-
      //- detailed
      //- detail-key="key"
      //- :opened-detailed="base.detailed_keys"

      // ↓これを追加するとまとめて開いたときすべての音が鳴ってしまう
      // :has-detailed-visible="row => sound_play('click')"

      //- b-table-column(v-slot="{row}" custom-key="key" field="key" :label="base.ArticleIndexColumnInfo.fetch('key').name" sortable numeric wkeyth="1" :visible="!!base.visible_hash.key") {{row.key}}

      //- sortable :visible="!!base.visible_hash.title"

      b-table-column(v-slot="{row}" custom-key="position"         field="position"         label="POS"    :width="1" numeric :visible="development_p") {{row.position + 1}}
      b-table-column(v-slot="{row}" custom-key="key"              field="key"              label="KEY"     :wkeyth="1" numeric)
        nuxt-link(:to="{name: 'library-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
          | {{row.key}}

      b-table-column(v-slot="{row}" custom-key="title"            field="title"            label="タイトル") {{row.title}}
      b-table-column(v-slot="{row}" custom-key="difficulty" field="difficulty" label="難易度" :width="1" numeric) {{row.difficulty}}

      //- nuxt-link(:to="{name: 'library-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
      //- | {{string_truncate(row.title, {length: s_config.TRUNCATE_MAX})}}

      //- b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.ArticleIndexColumnInfo.fetch('user_id').name" sortable :visible="base.scope === 'everyone'")
      //-   WkbkUserName(:user="row.user")
      //-
      //- b-table-column(v-slot="{row}" custom-key="book_title" field="book.title" :label="base.ArticleIndexColumnInfo.fetch('book_title').name" sortable :visible="!!base.visible_hash.book_title")
      //-   nuxt-link(:to="{name: 'library-books-book_key', params: {book_key: row.book.key}}" v-if="row.book")
      //-
      //-     | {{string_truncate(row.book.title, {length: s_config.TRUNCATE_MAX})}}({{row.book.articles_count}})
      //-
      //- b-table-column(v-slot="{row}" custom-key="lineage_key"         field="lineage.position"    :label="base.ArticleIndexColumnInfo.fetch('lineage_key').name" sortable :visible="!!base.visible_hash.lineage_key") {{row.lineage_key}}
      //- b-table-column(v-slot="{row}" custom-key="turn_max"            field="turn_max"            :label="base.ArticleIndexColumnInfo.fetch('turn_max').name"      sortable numeric :visible="!!base.visible_hash.turn_max")      {{row.turn_max}}
      //-
      //- b-table-column(v-slot="{row}" custom-key="owner_tag_list"    field="owner_tag_list"  :label="base.ArticleIndexColumnInfo.fetch('owner_tag_list').name" :visible="!!base.visible_hash.owner_tag_list")
      //-   //- b-taglist
      //-   b-tag.is-clickable.mr-1(v-for="tag in row.owner_tag_list" @click.native.stop="base.tag_search_handle(tag)" rounded)
      //-     | {{tag}}
      //-
      b-table-column(v-slot="{row}" custom-key="created_at" field="created_at" label="作成日時" :width="1") {{row_time_format(row.created_at)}}
      //- b-table-column(v-slot="{row}" custom-key="updated_at" field="updated_at" :label="更新") {{row_time_format(row.updated_at)}}
      //-
      //- b-table-column(v-slot="{row}" custom-key="operation" label="" width="1")
      //-   template(v-if="g_current_user && g_current_user.id === row.user.id || development_p")
      //-     nuxt-link(:to="{name: 'library-articles-article_key-edit', params: {article_key: row.key}}" @click.native="sound_play('click')") 編集
      b-table-column(v-slot="{row}" custom-key="operation" label="" width="1")
        b-button(     size="is-small" icon-left="arrow-up"   @click="up_down_handle(row, -1)")
        b-button.ml-1(size="is-small" icon-left="arrow-down" @click="up_down_handle(row, 1)")

      //- template(slot="empty" v-if="base.articles != null")
      //-   section.section.is-unselectable
      //-     .content.has-text-grey.has-text-centered
      //-       p
      //-         b-icon(icon="emoticon-sad" size="is-large")
      //-       p
      //-         | ひとつもありません

      //- template(slot="detail" slot-scope="props")
      //-   WkbkBookIndexDetail(:article="props.row")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkBookEditArticleIndexTable",
  mixins: [
    support_child,
  ],
  data() {
    return {
      dragging_row: null,
      from_index: null,
    }
  },
  methods: {
    up_down_handle(object, sign) {
      const index = this.base.book.articles.findIndex(e => e.id2 === object.id2)
      this.base.book.articles = this.ary_move(this.base.book.articles, index, index + sign)
    },

    dragstart_handle(payload) {
      this.dragging_row = payload.row
      this.from_index = payload.index
      payload.event.dataTransfer.effectAllowed = "copy"
    },
    dragover_handle(payload) {
      payload.event.dataTransfer.dropEffect = "copy"
      payload.event.target.closest("tr").classList.add("is-selected")
      payload.event.preventDefault()
    },
    dragleave_handle(payload) {
      payload.event.target.closest("tr").classList.remove("is-selected")
      payload.event.preventDefault()
    },
    drop_handle(payload) {
      payload.event.target.closest("tr").classList.remove("is-selected")
      const to_index = payload.index
      this.debug_alert(`${this.dragging_row.title}: ${this.from_index} -> ${to_index}`)
      // this.book.articles.splice(to_index, 0, this.book.articles[this.from_index])
      this.base.book.articles = this.ary_move(this.base.book.articles, this.from_index, to_index)
    },

    // https://qiita.com/nowayoutbut/items/991515b32805e21f8892
    ary_move(list, from, to) {
      const n = list.length
      list = [...list]

      // -1 なら配列の最後にする
      // -2 なら配列の最後のひとつ前にする
      if (to < 0) {
        to = n + to
      }

      // 要素2で to=2 なら 0 にする
      if (to >= n) {
        to = to - n
      }

      if (from === to || from > n - 1 || to > n - 1) {
        return list
      }
      const v = list[from]
      const tail = list.slice(from + 1)
      list.splice(from)
      Array.prototype.push.apply(list, tail)
      list.splice(to, 0, v)
      return list
    }

  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookEditArticleIndexTable
  .table
    th, td
      vertical-align: middle

  +mobile
    margin: $wkbk_share_gap * 0.75
  +tablet
    margin: $wkbk_share_gap

  th
    font-size: $size-7
  th, td
    vertical-align: middle
</style>
