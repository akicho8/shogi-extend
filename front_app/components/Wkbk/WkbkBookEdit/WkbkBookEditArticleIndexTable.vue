<template lang="pug">
.WkbkBookEditArticleIndexTable(v-if="base.book.articles.length >= 1 || true")
  //- .box.is-inline-block
  .title.is-6 並び替え
  .subtitle.is-7.mb-0 出題順序で「カスタマイズ」を選択したときの並び
  b-table.mt-1(
    :data="base.book.articles"
    :mobile-cards="false"
    :show-header="true"
    hoverable
    narrowed
    :row-class="() => 'is-clickable'"

    backend-sorting
    default-sort-direction="desc"
    @sort="base.sort_handle"

    draggable
    @dragstart="dragstart_handle"
    @drop="drop_handle"
    @dragover="dragover_handle"
    @dragleave="dragleave_handle"

    )
    //- :default-sort="[base.sort_column, base.sort_order]"

    b-table-column(v-slot="{row}" custom-key="operation" label="" :width="0" centered cell-class="px-1")
      .up_down_buttons.is-hidden-desktop
        b-button(size="is-small" icon-left="arrow-up"   @click="up_down_handle(row, -1)")
        b-button(size="is-small" icon-left="arrow-down" @click="up_down_handle(row, 1)")
      b-icon.is-hidden-touch.drag_icon(icon="drag-horizontal-variant" size="is-small")

    b-table-column(v-slot="{row}" custom-key="title" field="title" sortable label="タイトル" cell-class="is_line_break_on title_column" header-class="title_column")
      nuxt-link.article_title(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
        | {{row.title}}

    b-table-column(v-slot="{row}" custom-key="difficulty" field="difficulty" sortable label="難" numeric)
      | {{row.difficulty}}

    b-table-column(v-slot="{row}" custom-key="created_at" field="created_at" sortable label="作成日時")
      | {{row_time_format(row.created_at)}}
</template>

<script>
import { support_child } from "./support_child.js"
import { isMobile } from "@/components/models/is_mobile.js"

export default {
  name: "WkbkBookEditArticleIndexTable",
  mixins: [
    support_child,
  ],
  data() {
    return {
      dragging_row: null,
      from_index: null,
      run_count: 0,
    }
  },
  methods: {
    up_down_handle(object, sign) {
      const index = this.base.book.articles.findIndex(e => e.key === object.key)
      this.base.book.articles = this.ary_move(this.base.book.articles, index, index + sign)
      if (this.run_count === 0) {
        if (!isMobile.any()) {
          this.toast_ok("マウスでドラッグアンドドロップできますよ")
        }
      }
      this.run_count += 1
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

  // +mobile
  //   margin: 1rem

  +tablet
    // margin: 1.5rem

  th
    font-size: $size-7
  th, td
    vertical-align: middle

  .box
    .title, .subtitle
      white-space: nowrap

  .article_title
    max-width: 20rem

  .up_down_buttons
    .button:not(:first-child)
      margin-left: 0.25rem
  .drag_icon
    color: $grey-light

  .title_column
    +desktop
      padding-left: 0
</style>
