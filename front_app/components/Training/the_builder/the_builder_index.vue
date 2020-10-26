<template lang="pug">
.the_builder_index
  the_footer

  .primary_header
    .header_center_title
      template(v-if="bapp.page_info.tag")
        b-tag(attached closable @close="bapp.tag_search_handle(null)" rounded type="is-dark")
          | {{bapp.page_info.tag}}
      template(v-else)
        | 問題一覧

    ////////////////////////////////////////////////////////////////////////////////
    b-icon.header_item.with_icon.rjust(icon="plus" @click.native="bapp.builder_new_handle" v-if="permit_question_new_p")
    //////////////////////////////////////////////////////////////////////////////// メニューで開くタイプ
    b-dropdown.header_item.with_icon.ljust.px-3(:close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')")
      b-icon(slot="trigger" icon="menu")
      template(v-for="e in QuestionIndexColumnInfo.values")
        b-dropdown-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="e.key")
          .has-text-weight-bold(v-if="visible_hash[e.key]")
            | {{e.name}}
          .has-text-grey(v-else)
            | {{e.name}}

  ////////////////////////////////////////////////////////////////////////////////
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="question_tab_index" expanded @input="question_tab_index_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item(v-if="question_tab_available_p(tab_info)")
          template(slot="header")
            span
              | {{tab_info.name}}
              b-tag(rounded)
                | {{question_count_in_tab(tab_info)}}

  //////////////////////////////////////////////////////////////////////////////// シンプル横並び
  b-field.visible_toggle_checkboxes(grouped group-multiline v-if="false")
    template(v-for="e in QuestionIndexColumnInfo.values")
      .control
        b-checkbox(v-model="visible_hash[e.key]" size="is-small" @input="bool => cb_input_handle(e, bool)")
          | {{e.name}}

  b-table.index_table.is-size-7.mx-2.mt-4(
    v-if="bapp.questions"
    :data="bapp.questions"
    :mobile-cards="false"
    hoverable
    :narrowed="false"
    @click="row => false && app.ov_question_info_set(row.id)"

    paginated
    backend-pagination
    pagination-simple
    :page="bapp.page_info.page"
    :total="bapp.page_info.total"
    :per-page="bapp.page_info.per"
    @page-change="bapp.page_change_handle"

    backend-sorting
    :default-sort-direction="bapp.page_info.sort_order_default"
    :default-sort="[bapp.page_info.sort_column, bapp.page_info.sort_order]"
    @sort="bapp.sort_handle"

    detailed
    detail-key="id"
    :opened-detailed="detailed_ids"
    )

    b-table-column(v-slot="{row}" custom-key="id"                field="id"                :label="QuestionIndexColumnInfo.fetch('id').short_name"               sortable numeric :visible="!!visible_hash.id")               {{row.id}}
    b-table-column(v-slot="{row}" custom-key="user_id"           field="user.id"           :label="QuestionIndexColumnInfo.fetch('user_id').short_name"       sortable         :visible="!!visible_hash.user_id")
      a(@click.stop="app.ov_user_info_set(row.user.id)" :href="app.ov_user_url(row.user.id)")
        | {{row.user.name}}

    b-table-column(v-slot="{row}" custom-key="source_author"     field="source_author"     :label="QuestionIndexColumnInfo.fetch('source_author').short_name"       sortable         :visible="!!visible_hash.source_author")

      template(v-if="row.source_about_key === 'unknown'")
        | 不詳
      template(v-else-if="row.source_author")
        span.has-text-weight-bold
          template(v-if="row.source_media_url")
            a(:href="row.source_media_url" target="_blank")
              | {{row.source_author}}
              b-icon(icon="link" size="is-small")
          template(v-else)
            | {{row.source_author}}
      template(v-else)
        a(@click.prevent.stop="app.ov_user_info_set(row.user.id)" :href="app.ov_user_url(row.user.id)")
          | {{row.user.name}}

    b-table-column(v-slot="{row}" custom-key="title"             field="title"             :label="QuestionIndexColumnInfo.fetch('title').short_name"            sortable         :visible="!!visible_hash.title")
      a(@click.prevent.stop="app.ov_question_info_set(row.id)" :href="app.ov_question_url(row.id)")
        | {{string_truncate(row.title, {length: 20})}}

    b-table-column(v-slot="{row}" custom-key="histories_count"   field="histories_count"   :label="QuestionIndexColumnInfo.fetch('histories_count').short_name"  sortable numeric :visible="!!visible_hash.histories_count")  {{row.histories_count}}
    b-table-column(v-slot="{row}" custom-key="ox_record.o_rate"  field="ox_record.o_rate"  :label="QuestionIndexColumnInfo.fetch('o_rate').short_name"  sortable numeric :visible="!!visible_hash.o_rate")  {{float_to_perc(row.ox_record.o_rate)}} %
    b-table-column(v-slot="{row}" custom-key="ox_record.o_count" field="ox_record.o_count" :label="QuestionIndexColumnInfo.fetch('o_count').short_name" sortable numeric :visible="!!visible_hash.o_count") {{row.ox_record.o_count}}
    b-table-column(v-slot="{row}" custom-key="ox_record.x_count" field="ox_record.x_count" :label="QuestionIndexColumnInfo.fetch('x_count').short_name" sortable numeric :visible="!!visible_hash.x_count") {{row.ox_record.x_count}}
    b-table-column(v-slot="{row}" custom-key="messages_count"    field="messages_count"  :label="QuestionIndexColumnInfo.fetch('messages_count').short_name"      sortable numeric :visible="!!visible_hash.messages_count")      {{row.messages_count}}

    b-table-column(v-slot="{row}" custom-key="good_rate"         field="good_rate"         :label="QuestionIndexColumnInfo.fetch('good_rate').short_name"        sortable numeric :visible="!!visible_hash.good_rate") {{float_to_perc(row.good_rate)}} %
    b-table-column(v-slot="{row}" custom-key="good_marks_count"  field="good_marks_count"  :label="QuestionIndexColumnInfo.fetch('good_marks_count').short_name" sortable numeric :visible="!!visible_hash.good_marks_count") {{row.good_marks_count}}
    b-table-column(v-slot="{row}" custom-key="bad_marks_count"   field="bad_marks_count"   :label="QuestionIndexColumnInfo.fetch('bad_marks_count').short_name"  sortable numeric :visible="!!visible_hash.bad_marks_count")  {{row.bad_marks_count}}

    //- b-table-column(v-slot="{row}" custom-key="clip_marks_count"  field="clip_marks_count"  :label="QuestionIndexColumnInfo.fetch('clip_marks_count').short_name"      sortable numeric :visible="!!visible_hash.clip_marks_count")      {{row.clip_marks_count}}

    //- b-table-column(v-slot="{row}" custom-key="difficulty_level"  field="difficulty_level"  :label="QuestionIndexColumnInfo.fetch('difficulty_level').short_name" sortable numeric :visible="!!visible_hash.difficulty_level") {{row.difficulty_level}}
    //- b-table-column(v-slot="{row}" custom-key="time_limit_sec"    field="time_limit_sec"  :label="QuestionIndexColumnInfo.fetch('time_limit_sec').short_name" sortable numeric :visible="!!visible_hash.time_limit_sec") {{row.time_limit_sec}}秒

    b-table-column(v-slot="{row}" custom-key="lineage_key"    field="lineage_key"  :label="QuestionIndexColumnInfo.fetch('lineage_key').short_name" sortable :visible="!!visible_hash.lineage_key") {{row.lineage_key}}
    b-table-column(v-slot="{row}" custom-key="turn_max"  field="turn_max"  :label="QuestionIndexColumnInfo.fetch('turn_max').short_name"      sortable numeric :visible="!!visible_hash.turn_max")      {{row.turn_max}}
    b-table-column(v-slot="{row}" custom-key="moves_answers_count" field="moves_answers_count" :label="QuestionIndexColumnInfo.fetch('moves_answers_count').short_name" sortable numeric :visible="!!visible_hash.moves_answers_count") {{row.moves_answers_count}}

    b-table-column(v-slot="{row}" custom-key="owner_tag_list"    field="owner_tag_list"  :label="QuestionIndexColumnInfo.fetch('owner_tag_list').short_name" :visible="!!visible_hash.owner_tag_list")
      b-taglist
        b-tag.is_clickable(v-for="tag in row.owner_tag_list" @click.native.stop="bapp.tag_search_handle(tag)" rounded)
          | {{tag}}

    b-table-column(v-slot="{row}" custom-key="created_at"        field="created_at"        :label="QuestionIndexColumnInfo.fetch('created_at').short_name"       sortable         :visible="!!visible_hash.created_at")       {{row_time_format(row.created_at)}}
    b-table-column(v-slot="{row}" custom-key="updated_at"        field="updated_at"        :label="QuestionIndexColumnInfo.fetch('updated_at').short_name"       sortable         :visible="!!visible_hash.updated_at")       {{row_time_format(row.updated_at)}}

    b-table-column(v-slot="{row}" custom-key="operation" label="操作")
      template(v-if="app.current_user.id === row.user.id || app.debug_force_edit_p")
        a(@click.stop="bapp.question_edit_for(row)") 編集

    template(slot="empty")
      section.section.is-unselectable
        .content.has-text-grey.has-text-centered
          p
            b-icon(icon="emoticon-sad" size="is-large")
          p
            | ひとつもありません

    template(slot="detail" slot-scope="props")
      article.media
        figure.media-left
          //- <p class="image is-64x64">
          //-   <img src="/static/img/placeholder-128x128.png">
          //- </p>
          MyShogiPlayer(
            :run_mode="'view_mode'"
            :kifu_body="props.row.init_sfen"
            :flip_if_white="true"
            :start_turn="0"
            :summary_show="false"
            :slider_show="false"
            :controller_show="false"
            :setting_button_show="false"
            :theme="'simple'"
            :size="'default'"
            :sound_effect="false"
            :operation_disable="true"
            )
        .media-content
          .content
            //- template(v-if="props.row.direction_message && false")
            //-   p {{props.row.direction_message}}
            template(v-if="props.row.description")
              p.is_line_break_on.is-hidden-mobile {{props.row.description}}

  .has-text-right.has-text-centered-mobile.mt-3
    .buttons.is-inline-block.mx-2
      b-button(@click="detail_close_handle" icon-left="chevron-up")
      b-button(@click="detail_open_handle" icon-left="chevron-down")

  //- .columns
  //- .buttons.is-inlien-block
  //-   b-button(@click="detail_open_handle") 開く
  //-   b-button(@click="detail_close_handle") 閉じる
</template>

<script>
import { support } from "../support.js"

import ls_support from "@/components/models/ls_support.js"

import the_footer from "../the_footer.vue"

import { QuestionIndexColumnInfo } from "../models/question_index_column_info.js"

import MemoryRecord from 'js-memory-record'

// 「全体」があったりして構造が異なるのでサーバー側で定義したものを利用していない
class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "all",    name: "全体",   hidden_if_empty: false, },
      { key: "active", name: "公開",   hidden_if_empty: false, },
      { key: "draft",  name: "下書き", hidden_if_empty: true,  },
      { key: "trash",  name: "ゴミ箱", hidden_if_empty: true,  },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

export default {
  name: "the_builder_index",
  mixins: [
    support,
    ls_support,
  ],
  components: {
    the_footer,
  },
  data() {
    return {
      question_tab_index: null,
      visible_hash: null, //  { xxx: true, yyy: false } 形式
      detailed_ids: [],
    }
  },
  created() {
    // this.$gtag.event("open", {event_category: "問題一覧"})
    this.folder_active_handle()
    this.ls_setup()
  },
  mounted() {
    // 有効にすると localStorage をクリアする
    if (false) {
      this.$_ls_reset()
    }
  },

  methods: {
    // 「公開」選択
    folder_active_handle() {
      this.question_mode_select("active")
      this.bapp.folder_change_handle("active")
    },

    // 指定のタブを選択
    question_mode_select(tab_key) {
      this.question_tab_index = this.TabInfo.fetch(tab_key).code
    },

    // タブが変更されたとき
    question_tab_index_change_handle() {
      this.sound_play("click")
      this.say(this.question_current_tab_info.name)
      this.bapp.folder_change_handle(this.question_current_tab_info.key)
    },

    // このタブは表示するか？
    // ゴミ箱など常に0なので0のときは表示しない
    question_tab_available_p(tab_info) {
      if (tab_info.hidden_if_empty) {
        if (this.question_count_in_tab(tab_info) === 0) {
          return false
        }
      }
      return true
    },
    // このタブのレコード件数
    question_count_in_tab(tab_info) {
      return this.bapp.question_counts[tab_info.key] || 0
    },

    // チェックボックスが変更されたとき
    cb_input_handle(column, bool) {
      this.sound_play('click')
      if (bool) {
        this.say(column.name)
      }
    },

    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
      if (this.visible_hash[column.key]) {
        this.say(column.name)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// details
    detail_open_handle() {
      this.sound_play('click')
      this.detailed_ids = this.bapp.questions.map(e => e.id)
    },
    detail_close_handle() {
      this.sound_play('click')
      this.detailed_ids = []
    },
  },
  computed: {
    QuestionIndexColumnInfo() { return QuestionIndexColumnInfo },

    //////////////////////////////////////////////////////////////////////////////// タブ

    TabInfo() { return TabInfo },
    question_current_tab_info() { return this.TabInfo.fetch(this.question_tab_index) },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_default() {
      return {
        visible_hash: this.as_visible_hash(QuestionIndexColumnInfo.values),
      }
    },

    //////////////////////////////////////////////////////////////////////////////// details
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_index
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom

  .dropdown-menu
    min-width: 0
    a:focus
      outline: none

  .visible_toggle_checkboxes
    margin-top: 1.5rem
    justify-content: center

  .index_table
    th
      font-size: $size-10

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

    // モバイルでは MyShogiPlayer を横幅最大にしたいので横のパディングを取る
    +mobile
      .detail
        td, .detail-container
          padding: 0
</style>
