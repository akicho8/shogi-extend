<template lang="pug">
.WkbkBookEditArticleIndexTable
  //- .box.is-inline-block
  .title.is-6 並び替え
  .subtitle.is-7.mb-0 出題順序で「カスタマイズ」を選択したときの並び
  b-table.mt-1(
    :data="base.book.ordered_bookships"
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

    //- b-table-column(v-slot="{row}" custom-key="index" field="index" :width="'2.5rem'" label="#" centered sortable)
    //-   | {{row.index + 1}}

    b-table-column(v-slot="{row}" custom-key="operation" label="" :width="1" centered cell-class="px-1")
      .up_down_buttons.is-hidden-desktop
        b-button(size="is-small" icon-left="arrow-up"   @click="up_down_handle(row, -1)")
        b-button(size="is-small" icon-left="arrow-down" @click="up_down_handle(row, 1)")
      b-icon.is-hidden-touch.drag_icon(icon="drag-horizontal-variant" size="is-small")

    b-table-column(v-slot="{row}" custom-key="article.title" field="article.title" sortable label="タイトル" cell-class="is_line_break_on title_column" header-class="title_column")
      nuxt-link.article_title(:to="{name: 'rack-articles-article_key', params: {article_key: row.article.key}}" @click.native="sfx_click()")
        | {{row.article.title || "(no title)"}}
        b-icon.ml-1(:icon="FolderInfo.fetch(row.article.folder_key).icon" size="is-small" v-if="row.article.folder_key != 'public'")

    b-table-column(v-slot="{row}" custom-key="article.difficulty" field="article.difficulty" sortable centered label="難度" numeric)
      | {{row.article.difficulty}}

    b-table-column(v-slot="{row}" custom-key="article.turn_max" field="article.turn_max" sortable centered label="手数" numeric)
      | {{row.article.turn_max}}

    b-table-column(v-slot="{row}" custom-key="created_at" field="created_at" sortable centered label="追加日")
      | {{$time.format_row(row.created_at)}}

    b-table-column(v-slot="{row}" custom-key="article.created_at" field="article.created_at" sortable centered label="作成日")
      | {{$time.format_row(row.article.created_at)}}
</template>

<script>
import { support_child } from "./support_child.js"
import { MyMobile } from "@/components/models/my_mobile.js"

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
    // スマホで↓↑を押したとき
    up_down_handle(object, sign) {
      const index = this.base.book.ordered_bookships.findIndex(e => e.id === object.id)
      this.base.book.ordered_bookships = this.$gs.ary_move(this.base.book.ordered_bookships, index, index + sign)
      if (this.run_count === 0) {
        if (!MyMobile.mobile_p) {
          this.toast_ok("マウスでドラッグアンドドロップできますよ")
        }
      }
      this.run_count += 1
    },

    // マウスでドラッグ
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
      // this.book.ordered_bookships.splice(to_index, 0, this.book.ordered_bookships[this.from_index])
      this.base.book.ordered_bookships = this.$gs.ary_move(this.base.book.ordered_bookships, this.from_index, to_index)
    },
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
