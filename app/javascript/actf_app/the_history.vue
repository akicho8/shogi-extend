<template lang="pug">
.the_history.main_content
  .primary_header
    .has-text-weight-bold 問題履歴
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item.is-size-2(:label="tab_info.name")
  template(v-for="(row, i) in history_records")
    .row.is-flex
      .left_block.is-flex
        .ans_result
          template(v-if="row.ans_result.key === 'correct'")
            b-icon(icon="checkbox-blank-circle-outline" type="is-danger")
          template(v-if="row.ans_result.key === 'mistake'")
            b-icon(icon="close")
        img.board(:src="board_image_url(row)")
        figure.image.is-32x32
          img.is-rounded(:src="row.question.user.avatar_path")
        .question_block.is-flex
          .uegawa
            .has-text-weight-bold
              | {{row.question.user.name}}作
            .question_title(v-if="row.question.title")
              | {{row.question.title}}
            .question_description(v-if="row.question.description")
              | {{row.question.description}}
            .question_source_desc(v-if="row.question.source_desc")
              | {{row.question.source_desc}}
          .bottom_block.is-flex
            //- b-icon(icon="heart-outline" @click="heart_handle")
            .thumb_box(@click="good_mark_handle(row)" :class="{'has-text-primary': row.good_mark_on}")
              b-icon(icon="thumb-up")
              span.marks_count
                | {{row.question.good_marks_count}}
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

    board_image_url(row) {
      // return "/share-board.png?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&image_view_point=black&image_preset=small"
      const params = {
        format: "png",
        body: `position sfen ${row.question.init_sfen}`,
        image_view_point: "black",
      }
      const url = new URL(this.as_full_url("/share-board"))
      _.each(params, (v, k) => url.searchParams.set(k, v))
      return url.toString()
    },

    good_mark_handle(history) {
      this.silent_http_command("PUT", this.app.info.put_path, { favorite_update: true, question_id: history.question.id }, e => {
        if (e.x_resp) {
          this.$set(history, "good_mark_on", e.x_resp.good_mark_on)
          this.$set(history.question, "good_marks_count", history.question.good_marks_count + e.x_resp.diff)
        }
      })
    },
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
    padding-top: 0.3rem
    padding-bottom: 0.3rem

    &.active
      background-color: change_color($warning, $lightness: 97%)

    &:not(:first-child)
      border-top: 1px solid $grey-lighter

    justify-content: space-between
    align-items: flex-start

    .ans_result
      margin-top: 0.5rem
      margin-left: 1.0rem
    .board
      height: 128px
      width: 172px
      object-fit: cover
      object-position: 50% 50%
    .image
      margin-top: 0.25rem
    .question_block
      margin-left: 0.5rem
      flex-direction: column
      justify-content: space-between
      align-items: flex-start
      .question_title
      .bottom_block
        .thumb_box
          .marks_count
            margin-left: 0.25rem
            vertical-align: top
</style>
