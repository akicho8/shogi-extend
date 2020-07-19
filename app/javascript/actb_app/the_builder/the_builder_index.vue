<template lang="pug">
.the_builder_index
  the_footer

  .primary_header
    .header_center_title
      template(v-if="$parent.page_info.tag")
        b-tag(attached closable @close="$parent.tag_search_handle(null)" rounded type="is-dark")
          | {{$parent.page_info.tag}}
      template(v-else)
        | 問題一覧

    ////////////////////////////////////////////////////////////////////////////////
    b-icon.header_item.with_icon.rjust(icon="plus" @click.native="$parent.builder_new_handle")
    //////////////////////////////////////////////////////////////////////////////// メニューで開くタイプ
    b-dropdown.header_item.with_icon.ljust.px-3(:close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')")
      b-icon(slot="trigger" icon="menu")
      template(v-for="e in QuestionIndexColumnInfo.values")
        template(v-if="e.scope.includes(app.user_type)")
          b-dropdown-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="e.key")
            .has-text-weight-bold(v-if="visible_hash[e.key]")
              | {{e.name}}
            .has-text-grey(v-else)
              | {{e.name}}

  ////////////////////////////////////////////////////////////////////////////////
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="question_tab_index" expanded @change="question_tab_index_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item
          template(slot="header")
            span
              | {{tab_info.name}}
              b-tag(rounded)
                | {{$parent.question_counts[tab_info.key] || 0}}

  //////////////////////////////////////////////////////////////////////////////// シンプル横並び
  b-field.visible_toggle_checkboxes(grouped group-multiline v-if="false")
    template(v-for="e in QuestionIndexColumnInfo.values")
      .control(v-if="e.scope.includes(app.user_type)")
        b-checkbox(v-model="visible_hash[e.key]" size="is-small" @input="bool => cb_input_handle(e, bool)")
          | {{e.name}}

  b-table.index_table.is-size-7.mx-2.mt-4(
    v-if="$parent.questions"
    :data="$parent.questions"
    :mobile-cards="false"
    hoverable
    :narrowed="false"
    @click="row => false && app.ov_question_info_set(row.id)"

    paginated
    backend-pagination
    pagination-simple
    :page="$parent.page_info.page"
    :total="$parent.page_info.total"
    :per-page="$parent.page_info.per"
    @page-change="$parent.page_change_handle"

    backend-sorting
    :default-sort-direction="$parent.page_info.sort_order_default"
    :default-sort="[$parent.page_info.sort_column, $parent.page_info.sort_order]"
    @sort="$parent.sort_handle"
    )

    template(slot-scope="props")
      b-table-column(custom-key="id"                field="id"                :label="QuestionIndexColumnInfo.fetch('id').short_name"               sortable numeric :visible="visible_hash.id")               {{props.row.id}}
      b-table-column(custom-key="user_id"           field="user.id"           :label="QuestionIndexColumnInfo.fetch('user_id').short_name"       sortable         :visible="visible_hash.user_id && question_current_tab_info.user_id_column_show_p")
        a(@click.stop="app.ov_user_info_set(props.row.user.id)")
          | {{props.row.user.name}}
      b-table-column(custom-key="title"             field="title"             :label="QuestionIndexColumnInfo.fetch('title').short_name"            sortable         :visible="visible_hash.title")
        a {{props.row.title}}
      b-table-column(custom-key="histories_count"   field="histories_count"   :label="QuestionIndexColumnInfo.fetch('histories_count').short_name"  sortable numeric :visible="visible_hash.histories_count")  {{props.row.histories_count}}
      b-table-column(custom-key="ox_record.o_rate"  field="ox_record.o_rate"  :label="QuestionIndexColumnInfo.fetch('o_rate').short_name"  sortable numeric :visible="visible_hash.o_rate")  {{float_to_perc(props.row.ox_record.o_rate)}} %
      b-table-column(custom-key="ox_record.o_count" field="ox_record.o_count" :label="QuestionIndexColumnInfo.fetch('o_count').short_name" sortable numeric :visible="visible_hash.o_count") {{props.row.ox_record.o_count}}
      b-table-column(custom-key="ox_record.x_count" field="ox_record.x_count" :label="QuestionIndexColumnInfo.fetch('x_count').short_name" sortable numeric :visible="visible_hash.x_count") {{props.row.ox_record.x_count}}
      b-table-column(custom-key="messages_count"    field="messages_count"  :label="QuestionIndexColumnInfo.fetch('messages_count').short_name"      sortable numeric :visible="visible_hash.messages_count")      {{props.row.messages_count}}

      b-table-column(custom-key="good_rate"         field="good_rate"         :label="QuestionIndexColumnInfo.fetch('good_rate').short_name"        sortable numeric :visible="visible_hash.good_rate") {{float_to_perc(props.row.good_rate)}} %
      b-table-column(custom-key="good_marks_count"  field="good_marks_count"  :label="QuestionIndexColumnInfo.fetch('good_marks_count').short_name" sortable numeric :visible="visible_hash.good_marks_count") {{props.row.good_marks_count}}
      b-table-column(custom-key="bad_marks_count"   field="bad_marks_count"   :label="QuestionIndexColumnInfo.fetch('bad_marks_count').short_name"  sortable numeric :visible="visible_hash.bad_marks_count")  {{props.row.bad_marks_count}}

      b-table-column(custom-key="clip_marks_count"  field="clip_marks_count"  :label="QuestionIndexColumnInfo.fetch('clip_marks_count').short_name"      sortable numeric :visible="visible_hash.clip_marks_count")      {{props.row.clip_marks_count}}

      //- b-table-column(custom-key="difficulty_level"  field="difficulty_level"  :label="QuestionIndexColumnInfo.fetch('difficulty_level').short_name" sortable numeric :visible="visible_hash.difficulty_level") {{props.row.difficulty_level}}
      //- b-table-column(custom-key="time_limit_sec"    field="time_limit_sec"  :label="QuestionIndexColumnInfo.fetch('time_limit_sec').short_name" sortable numeric :visible="visible_hash.time_limit_sec") {{props.row.time_limit_sec}}秒

      b-table-column(custom-key="lineage_key"    field="lineage_key"  :label="QuestionIndexColumnInfo.fetch('lineage_key').short_name" sortable :visible="visible_hash.lineage_key") {{props.row.lineage_key}}

      b-table-column(custom-key="owner_tag_list"    field="owner_tag_list"  :label="QuestionIndexColumnInfo.fetch('owner_tag_list').short_name" :visible="visible_hash.owner_tag_list")
        b-taglist
          b-tag.is_clickable(v-for="tag in props.row.owner_tag_list" @click.native.stop="$parent.tag_search_handle(tag)" rounded)
            | {{tag}}

      b-table-column(custom-key="created_at"        field="created_at"        :label="QuestionIndexColumnInfo.fetch('created_at').short_name"       sortable         :visible="visible_hash.created_at")       {{row_time_format(props.row.created_at)}}
      b-table-column(custom-key="updated_at"        field="updated_at"        :label="QuestionIndexColumnInfo.fetch('updated_at').short_name"       sortable         :visible="visible_hash.updated_at")       {{row_time_format(props.row.updated_at)}}

      b-table-column(custom-key="operation" label="操作")
        template(v-if="app.current_user.id === props.row.user.id || app.debug_force_edit_p")
          a(@click.stop="$parent.question_edit_for(props.row)") 編集

    template(slot="empty")
      section.section.is-unselectable
        .content.has-text-grey.has-text-centered
          p
            b-icon(icon="emoticon-sad" size="is-large")
          p
            | ひとつもありません
</template>

<script>
import { support } from "../support.js"

import ls_support from "../../../../app/javascript/ls_support.js"

import the_footer from "../the_footer.vue"

import { QuestionIndexColumnInfo } from "../models/question_index_column_info.js"

import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "all",    name: "全体",   user_id_column_show_p: true,  },
      { key: "active", name: "公開",   user_id_column_show_p: false, },
      { key: "draft",  name: "下書き", user_id_column_show_p: false, },
      { key: "trash",  name: "ゴミ箱", user_id_column_show_p: false, },
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
    }
  },
  created() {
    this.$gtag.event("open", {event_category: "問題一覧"})
    this.folder_active_handle()
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
      this.$parent.folder_change_handle("active")
    },

    // 指定のタブを選択
    question_mode_select(tab_key) {
      this.question_tab_index = this.TabInfo.fetch(tab_key).code
    },

    // タブが変更されたとき
    question_tab_index_change_handle() {
      this.sound_play("click")
      this.say(this.question_current_tab_info.name)
      this.$parent.folder_change_handle(this.question_current_tab_info.key)
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
  },
  computed: {
    QuestionIndexColumnInfo() { return QuestionIndexColumnInfo },

    //////////////////////////////////////////////////////////////////////////////// タブ

    TabInfo() { return TabInfo },
    question_current_tab_info() { return this.TabInfo.fetch(this.question_tab_index) },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_data() {
      return {
        visible_hash: this.as_visible_hash(QuestionIndexColumnInfo.values),
      }
    },
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

  .tags
    flex-wrap: nowrap
</style>
