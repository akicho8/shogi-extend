<template lang="pug">
.the_history.main_content
  .primary_header
    .has-text-weight-bold 問題履歴
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item.is-size-2(:label="tab_info.name")
  .columns.is-centered.is-marginless
    .column.is-paddingless
      template(v-for="(row, i) in history_records")
        .row.is-flex
          .left_block.is-flex
            .ans_result
              template(v-if="row.ans_result.key === 'correct'")
                b-icon(icon="checkbox-blank-circle-outline")
              template(v-if="row.ans_result.key === 'mistake'")
                b-icon(icon="close")
            figure.image.is-48x48
              img.is-rounded(:src="row.question.user.avatar_path")
            .question_block
              .name
                | {{row.question.title}}
              .user
                | {{row.question.user.name}}作
          .right_block.is-flex
            .ans_result
              template(v-if="row.ans_result.key === 'correct'")
                b-icon(icon="checkbox-blank-circle-outline")
              template(v-if="row.ans_result.key === 'mistake'")
                b-icon(icon="close")
            b-icon(icon="heart-outline")
  debug_print
</template>

<script>
import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "history",  name: "履歴",       },
      { key: "favorite", name: "お気に入り", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import support from "./support.js"

export default {
  name: "the_history",
  mixins: [
    support,
  ],
  components: {
  },
  props: {
  },
  data() {
    return {
      tab_index: null,
      history_records: null,
    }
  },

  created() {
    this.app.lobby_close()

    this.sound_play("click")
    this.mode_select("history")
    this.tab_change_handle()
  },

  watch: {
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    history_handle() {
      this.mode_select("history")

      if (this.history_records) {
      } else {
        this.http_get_command(this.app.info.put_path, { history_fetch: true }, e => {
          if (e.history_records) {
            this.history_records = e.history_records
          }
        })
      }
    },

    favorite_handle() {
      this.mode_select("favorite")
    },

    ////////////////////////////////////////////////////////////////////////////////

    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    tab_change_handle() {
      this[this.current_tab_info.handle_method_name]()
    },

    ////////////////////////////////////////////////////////////////////////////////

  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_history
  @extend %padding_top2

  .main_tabs
    a
      padding-top: 1rem
    .tab-content
      padding: 0
      padding-top: 0

  .row
    padding-top: 1rem
    padding-bottom: 0.7rem

    &.active
      background-color: change_color($warning, $lightness: 97%)

    &:not(:first-child)
      border-top: 1px solid $grey-lighter

    justify-content: space-between
    align-items: center

    .left_block
      align-items: center
      .ans_result
        margin-left: 1.8rem
      .image
        margin-left: 1rem
        img
          height: 48px
      .question_block
        margin-left: 1rem
        .name
        .user
    .right_block
      width: 8rem

</style>
