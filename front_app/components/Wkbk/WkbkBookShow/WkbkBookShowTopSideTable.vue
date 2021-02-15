<template lang="pug">
.WkbkBookShowTopSideTable
  //- .card.is-inline-block
  //-   .card-content
  //-     p.title.is-size-6
  //-       | 結果
  //-     //- p.subtitle
  //-     //-   | Jeff Atwood
  //-     p
  //-       | {{base.ox_summary}}
  //-   .card-footer
  //-     p.card-footer-item
  //-       TweetButton(:body="base.ox_tweet_body") Tweet

  nav.panel.is-twitter.mb-0(v-if="base.journal_hash")
    p.panel-heading
      | 結果
    .panel-block.ox_summary
      | {{base.ox_summary}}
    .panel-block
      TweetButton.is-link.is-outlined.is-fullwidth(:body="base.ox_tweet_body" size="" @after_click="sound_play('click')") ツイート

  nav.panel.mb-0
    p.panel-heading
      | 問題リスト
    .panel-block.op_buttons
      b-button.is-fullwidth(@click="base.op_select_x_handle")
        | 不正解のみ残す
      b-button.is-fullwidth(@click="base.op_shuffle_handle")
        | シャッフル
      b-button.is-fullwidth(@click="base.op_revert_handle")
        | 元に戻す
    .panel-block
      b-numberinput(controls-position="compact" expanded v-model="base.current_index_human" :min="1" :max="base.xitems.length" :exponential="true" @click.native="sound_play('click')")
      //- b-button.is-fullwidth(@click="base.op_select_x_handle")
      //-   | 不正解のみ残す
    .panel-block.is-block
      b-table(
        v-if="base.xitems.length >= 1"
        :data="base.xitems"
        :mobile-cards="false"
        :show-header="true"
        @click="row => select_handle(row)"
        :row-class="(e, i) => (i === base.current_index) && 'current_row'"
        hoverable
        )
        //- :row-class="(e, i) => (i === base.current_index) && 'is-selected'"
        //- narrowed
        //- :row-class="() => 'is-clickable'"
        //- draggable
        //- @dragstart="dragstart_handle"
        //- @drop="drop_handle"
        //- @dragover="dragover_handle"
        //- @dragleave="dragleave_handle"
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

        //- b-table-column(v-slot="{row}" custom-key="key" field="key" :label="base.ArticleIndexColumnInfo.fetch('key').name" sortable numeric width="1" :visible="!!base.visible_hash.key") {{row.key}}

        //- sortable :visible="!!base.visible_hash.title"

        //- b-table-column(v-slot="{row}" custom-key="operation" label="")
        //-   b-button(     size="is-small" icon-left="arrow-up"   @click="up_down_handle(row, -1)")
        //-   b-button.ml-1(size="is-small" icon-left="arrow-down" @click="up_down_handle(row, 1)")

        //- b-table-column(v-slot="{row}" custom-key="position"         field="position"         label="POS"    :width="1" numeric :visible="development_p") {{row.position + 1}}

        //- b-table-column(v-slot="{row}" custom-key="key"              field="key"              label="KEY"     :width="1" numeric)
        //-   nuxt-link(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
        //-     | {{row.key}}

        b-table-column(v-slot="{row}" custom-key="index" field="index" label="" centered cell-class="index_column")
          //- template(v-if="row.index === base.current_index")
          //-   b-tag(rounded type="is-primary")
          //-     | {{index + 1}}
          //- template(v-else)
          //- :cell-class="row.index === base.current_index ? 'has-text-weight-bold' : ''"
          //- b-icon(icon="play" type="is-primary" v-if="row.index === base.current_index")
          //- span.has-text-grey-light(v-else) {{row.index + 1}}
          | {{row.index + 1}}

        b-table-column(v-slot="{row}" custom-key="title"            field="title"            label="問題" cell-class="is_line_break_on")

          //- b-table-column(v-slot="e" custom-key="spent_sec" field="spent_sec" label="時間" numeric)
          //-   | {{e.index}}
          //- | {{journal_time_format(journal_hash[e.index])}}
          //- nuxt-link.article_title(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")

          //- nuxt-link(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
          //-   span.has-text-grey-dark
          //-     | {{row.title}}
          | {{row.article.title}}

        b-table-column(v-slot="{row}" custom-key="answer_kind_key" field="answer_kind_key" label="解" centered)
          b-icon(v-bind="base.journal_row_icon_attrs_for(row)")

        b-table-column(v-slot="{row}" custom-key="spent_sec" field="spent_sec" label="時間" centered)
          | {{base.journal_row_time_format_at(row)}}

        b-table-column(v-slot="{row}" custom-key="difficulty" field="difficulty" label="難易度" :width="20" centered :visible="false")
          | {{row.article.difficulty}}

        //- nuxt-link(:to="{name: 'rack-articles-article_key', params: {article_key: row.key}}" @click.native="sound_play('click')")
        //- | {{string_truncate(row.title, {length: s_config.TRUNCATE_MAX})}}

        //- b-table-column(v-slot="{row}" custom-key="user_id" field="user.name" :label="base.ArticleIndexColumnInfo.fetch('user_id').name" sortable :visible="base.scope === 'everyone'")
        //-   WkbkUserName(:user="row.user")
        //-
        //- b-table-column(v-slot="{row}" custom-key="book_title" field="book.title" :label="base.ArticleIndexColumnInfo.fetch('book_title').name" sortable :visible="!!base.visible_hash.book_title")
        //-   nuxt-link(:to="{name: 'rack-books-book_key', params: {book_key: row.book.key}}" v-if="row.book")
        //-
        //-     | {{string_truncate(row.book.title, {length: s_config.TRUNCATE_MAX})}}({{row.book.bookships_count}})
        //-
        //- b-table-column(v-slot="{row}" custom-key="lineage_key"         field="lineage.position"    :label="base.ArticleIndexColumnInfo.fetch('lineage_key').name" sortable :visible="!!base.visible_hash.lineage_key") {{row.lineage_key}}
        //- b-table-column(v-slot="{row}" custom-key="turn_max"            field="turn_max"            :label="base.ArticleIndexColumnInfo.fetch('turn_max').name"      sortable numeric :visible="!!base.visible_hash.turn_max")      {{row.turn_max}}
        //-
        //- b-table-column(v-slot="{row}" custom-key="tag_list"    field="tag_list"  :label="base.ArticleIndexColumnInfo.fetch('tag_list').name" :visible="!!base.visible_hash.tag_list")
        //-   //- b-taglist
        //-   b-tag.is-clickable.mr-1(v-for="tag in row.tag_list" @click.native.stop="base.tag_search_handle(tag)" rounded)
        //-     | {{tag}}
        //-
        //- b-table-column(v-slot="{row}" custom-key="created_at" field="created_at" label="作成日時") {{row_time_format(row.created_at)}}
        b-table-column(v-slot="{row}" custom-key="updated_at" field="updated_at" label="最終更新" :visible="false")
          | {{row_time_format(row.article.updated_at)}}
        //-
        //- b-table-column(v-slot="{row}" custom-key="operation" label="" width="1")
        //-   template(v-if="g_current_user && g_current_user.id === row.user.id || development_p")
        //-     nuxt-link(:to="{name: 'rack-articles-article_key-edit', params: {article_key: row.key}}" @click.native="sound_play('click')") 編集

        //- b-table-column(v-slot="{row}" custom-key="operation" label="" :width="0")
        //-   b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')" @click.native.prevent)
        //-     b-icon(icon="dots-vertical" slot="trigger")
            //- b-dropdown-item.px-4(@click.native.stop="base.cb_toggle_handle(e)" :key="e.key" v-if="e.togglable")
            //-   span(:class="{'has-text-grey': !base.visible_hash[e.key], 'has-text-weight-bold': base.visible_hash[e.key]}") {{e.name}}
            //- b-dropdown-item(:separator="true")
            //- b-dropdown-item(@click="base.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0})") 1行 7文字
            //- b-dropdown-item(@click="base.rule_set({initial_main_min: 30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0})") 1行 5文字
            //- b-dropdown-item(@click="base.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0})") 2行 7文字

          //- template(v-if="g_current_user && g_current_user.id === row.user.id || development_p")
          //-   nuxt-link(:to="{name: 'rack-articles-article_key-edit', params: {article_key: row.key}}" @click.native="sound_play('click')") 編集

        //- template(slot="empty" v-if="base.xitems != null")
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
import { isMobile } from "@/components/models/is_mobile.js"

export default {
  name: "WkbkBookShowTopSideTable",
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
    select_handle(row) {
      this.__assert__(row.index != null, "row.index != null")
      if (this.base.current_index != row.index) {
        this.sound_play("click")
        this.base.current_index = row.index
      }
    },

    up_down_handle(object, sign) {
      const index = this.base.book.xitems.findIndex(e => e.key === object.key)
      this.base.book.xitems = this.ary_move(this.base.book.xitems, index, index + sign)
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
      // this.book.xitems.splice(to_index, 0, this.book.xitems[this.from_index])
      this.base.book.xitems = this.ary_move(this.base.book.xitems, this.from_index, to_index)
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
.WkbkBookShowTopSideTable
  // .table
  //   tr, td
  //     height: 5rem

  // .table
  //   th, td
  //     vertical-align: middle

  +mobile
    // margin-top: 1rem
    // padding: 0
  +tablet
    // padding: 0 1rem 0 0

  .panel:not(:first-child)
    margin-top: 1.25rem // 理論的には 1rem が正しいが影で狭く見えるため広くする

  th
    font-size: $size-7
  th, td
    vertical-align: middle

  .b-table
    td
      &.index_column
        padding: 0
    .index_column
      color: $grey-light
    .current_row
      .index_column
        background-color: $primary
        color: $white

  // .box
  //   .title, .subtitle
  //     white-space: nowrap

  .ox_summary
    white-space: pre-wrap

  .op_buttons
    .button:not(:first-child)
      margin-top: 0.5rem
    flex-direction: column

  // .article_title
  //   // display: inline
  //   // max-width: 14rem
</style>
