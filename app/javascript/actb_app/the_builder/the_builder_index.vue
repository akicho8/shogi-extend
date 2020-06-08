<template lang="pug">
.the_builder_index
  .primary_header
    .header_center_title 問題一覧
    b-icon.header_item.with_icon.rjust(icon="plus" @click.native="$parent.builder_new_handle")

  b-field.visible_toggle_checkboxes(grouped group-multiline)
    .control(v-for="e in QuestionColumnInfo.values")
      b-checkbox(v-model="visible_hash[e.key]" size="is-small" @input="bool => cb_input_handle(e, bool)")
        | {{e.name}}

  b-table.index_table(
    v-if="$parent.questions"
    :data="$parent.questions"
    :mobile-cards="false"
    hoverable
    :narrowed="false"
    @click="row => app.ov_question_info_set(row.id)"

    paginated
    backend-pagination
    pagination-simple
    :current-page="$parent.page"
    :total="$parent.total"
    :per-page="$parent.per"
    @page-change="$parent.page_change_handle"

    backend-sorting
    :default-sort-direction="$parent.sort_order_default"
    :default-sort="[$parent.sort_column, $parent.sort_order]"
    @sort="$parent.sort_handle"
  )
    template(slot-scope="props")
      //- b-table-column(label="")
      //-   a(@click="app.ov_question_info_set(props.row.id)")
      //-     b-icon(icon="eye-outline" size="is-small")

      b-table-column(field="id"               :label="QuestionColumnInfo.fetch('id').short_name"               sortable numeric :visible="visible_hash.id")               {{props.row.id}}
      b-table-column(field="title"            :label="QuestionColumnInfo.fetch('title').short_name"            sortable         :visible="visible_hash.title")
        a {{props.row.title || '？'}}
      b-table-column(field="difficulty_level" :label="QuestionColumnInfo.fetch('difficulty_level').short_name" sortable numeric :visible="visible_hash.difficulty_level") {{props.row.difficulty_level}}
      b-table-column(field="o_count"          :label="QuestionColumnInfo.fetch('o_count').short_name"          sortable numeric :visible="visible_hash.o_count")          {{props.row.o_count}}
      b-table-column(field="x_count"          :label="QuestionColumnInfo.fetch('x_count').short_name"          sortable numeric :visible="visible_hash.x_count")          {{props.row.x_count}}
      b-table-column(field="histories_count"  :label="QuestionColumnInfo.fetch('histories_count').short_name"  sortable numeric :visible="visible_hash.histories_count")  {{props.row.histories_count}}
      b-table-column(field="good_marks_count" :label="QuestionColumnInfo.fetch('good_marks_count').short_name" sortable numeric :visible="visible_hash.good_marks_count") {{props.row.good_marks_count}}
      b-table-column(field="bad_marks_count"  :label="QuestionColumnInfo.fetch('bad_marks_count').short_name"  sortable numeric :visible="visible_hash.bad_marks_count")  {{props.row.bad_marks_count}}
      b-table-column(field="clip_marks_count"      :label="QuestionColumnInfo.fetch('clip_marks_count').short_name"      sortable numeric :visible="visible_hash.clip_marks_count")      {{props.row.clip_marks_count}}
      b-table-column(field="updated_at"       :label="QuestionColumnInfo.fetch('updated_at').short_name"       sortable         :visible="visible_hash.updated_at")       {{row_time_format(props.row.updated_at)}}

      b-table-column(label="操作")
        a(@click.stop="$parent.question_edit_of(props.row)")
          b-icon(icon="pencil-outline" size="is-small")
        //- .buttons.are-small
        //-   a.button.is-small(@click="$parent.question_edit_of(props.row)") 編集
        //-   a.button.is-small(@click="app.ov_question_info_set(props.row.id)") 表示

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
import ls_support from "ls_support.js"
import { QuestionColumnInfo } from "../models/question_column_info.js"

export default {
  name: "the_builder_index",
  mixins: [
    support,
    ls_support,
  ],
  data() {
    return {
      visible_hash: null, //  { xxx: true, yyy: false } 形式
    }
  },

  mounted() {
    // localStorage をクリア
    // this.$_ls_reset()
  },

  methods: {
    cb_input_handle(column, bool) {
      this.sound_play('click')
      if (bool) {
        this.talk(column.name, {rate: 1.5})
      }
    }
  },

  computed: {
    QuestionColumnInfo() { return QuestionColumnInfo },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_data() {
      return {
        visible_hash: this.as_visible_hash(QuestionColumnInfo.values),
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder_index
  @extend %padding_top_for_primary_header
  .primary_header
    justify-content: space-between

  .visible_toggle_checkboxes
    margin-top: 1.5rem
    justify-content: center
  .index_table
    margin: 0 0.4rem
</style>
