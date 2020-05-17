<template lang="pug">
.the_builder_index
  b-field.visible_toggle_checkboxes(grouped group-multiline)
    .control(v-for="e in ColumnInfo.values")
      b-checkbox(v-model="visible_hash[e.key]" size="is-small" @input="bool => cb_input_handle(e, bool)")
        | {{e.name}}

  b-table.index_table(
    v-if="$parent.questions"
    :data="$parent.questions"
    :mobile-cards="false"
    hoverable
    :narrowed="false"
    @click="row => app.overlay_record_set(row.id)"

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
      //-   a(@click="app.overlay_record_set(props.row.id)")
      //-     b-icon(icon="eye-outline" size="is-small")

      b-table-column(field="id"               :label="ColumnInfo.fetch('id').short_name"               sortable numeric :visible="visible_hash.id")               {{props.row.id}}
      b-table-column(field="title"            :label="ColumnInfo.fetch('title').short_name"            sortable         :visible="visible_hash.title")
        a {{props.row.title || '？'}}
      b-table-column(field="difficulty_level" :label="ColumnInfo.fetch('difficulty_level').short_name" sortable numeric :visible="visible_hash.difficulty_level") {{props.row.difficulty_level}}
      b-table-column(field="o_count"          :label="ColumnInfo.fetch('o_count').short_name"          sortable numeric :visible="visible_hash.o_count")          {{props.row.o_count}}
      b-table-column(field="x_count"          :label="ColumnInfo.fetch('x_count').short_name"          sortable numeric :visible="visible_hash.x_count")          {{props.row.x_count}}
      b-table-column(field="histories_count"  :label="ColumnInfo.fetch('histories_count').short_name"  sortable numeric :visible="visible_hash.histories_count")  {{props.row.histories_count}}
      b-table-column(field="good_marks_count" :label="ColumnInfo.fetch('good_marks_count').short_name" sortable numeric :visible="visible_hash.good_marks_count") {{props.row.good_marks_count}}
      b-table-column(field="bad_marks_count"  :label="ColumnInfo.fetch('bad_marks_count').short_name"  sortable numeric :visible="visible_hash.bad_marks_count")  {{props.row.bad_marks_count}}
      b-table-column(field="clips_count"      :label="ColumnInfo.fetch('clips_count').short_name"      sortable numeric :visible="visible_hash.clips_count")      {{props.row.clips_count}}
      b-table-column(field="updated_at"       :label="ColumnInfo.fetch('updated_at').short_name"       sortable         :visible="visible_hash.updated_at")       {{row_time_format(props.row.updated_at)}}

      b-table-column(label="操作")
        a(@click.stop="$parent.question_edit_of(props.row)")
          b-icon(icon="pencil-outline" size="is-small")
        //- .buttons.are-small
        //-   a.button.is-small(@click="$parent.question_edit_of(props.row)") 編集
        //-   a.button.is-small(@click="app.overlay_record_set(props.row.id)") 表示

    template(slot="empty")
      section.section.is-unselectable
        .content.has-text-grey.has-text-centered
          p
            b-icon(icon="emoticon-sad" size="is-large")
          p
            | ひとつもありません
</template>

<script>
import support from "./support.js"
import ls_support from "ls_support.js"

import MemoryRecord from 'js-memory-record'

class ColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",               name: "ID",         short_name: "ID",       visible: true,  },
      { key: "title",            name: "タイトル",   short_name: "タイトル", visible: true,  },
      { key: "difficulty_level", name: "難易度",     short_name: "難",       visible: false, },
      { key: "o_count",          name: "正解数",     short_name: "正解",     visible: false, },
      { key: "x_count",          name: "誤答数",     short_name: "誤答",     visible: false, },
      { key: "histories_count",  name: "履歴",       short_name: "履歴",     visible: false, },
      { key: "good_marks_count", name: "高評価",     short_name: "高評",     visible: true,  },
      { key: "bad_marks_count",  name: "低評価",     short_name: "低評",     visible: true,  },
      { key: "clips_count",      name: "お気に入り", short_name: "お気",     visible: false, },
      { key: "updated_at",       name: "更新日時",   short_name: "更新",     visible: true,  },
    ]
  }
}

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
    ColumnInfo() { return ColumnInfo },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_data() {
      return {
        visible_hash: this.as_visible_hash(ColumnInfo.values),
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_builder_index
  .visible_toggle_checkboxes
    margin-top: 1.5rem
    justify-content: center
  .index_table
    margin: 0 0.4rem
</style>
