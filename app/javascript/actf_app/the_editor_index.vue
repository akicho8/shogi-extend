<template lang="pug">
b-table.the_editor_index(
  v-if="$parent.questions"
  :data="$parent.questions"
  mobile-cards
  hoverable
  narrowed

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
    b-table-column(field="id" label="ID" sortable) {{props.row.id}}
    b-table-column(field="title" label="タイトル" sortable) {{props.row.title || '？'}}
    b-table-column(field="difficulty_level" label="難易度" sortable) {{props.row.difficulty_level}}
    b-table-column(field="moves_answers_count" label="解答数" sortable) {{props.row.moves_answers.length}}
    b-table-column(field="updated_at" label="更新日時" sortable) {{row_time_format(props.row.updated_at)}}
    b-table-column(label="")
      a(@click="$parent.question_edit_of(props.row)") 編集

  template(slot="empty")
    section.section.is-unselectable
      .content.has-text-grey.has-text-centered
        p
          b-icon(icon="emoticon-sad" size="is-large")
        p
          | ひとつもありません
</template>

<script>
import the_support from './the_support'

export default {
  name: "the_editor_index",
  mixins: [
    the_support,
  ],
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_editor_index
</style>
