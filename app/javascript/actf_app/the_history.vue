<template lang="pug">
.the_history.main_content
  //- template(v-if="overlay_question")
  //-   .show_layout
  //-     .primary_header
  //-       b-icon.back_link_icon.is_clickable(icon="arrow-left" @click.native="board_close")
  //-       .center_title_block.has-text-weight-bold.has-text-centered
  //-         | {{overlay_question.title}}
  //-     shogi_player(
  //-       :run_mode="'play_mode'"
  //-       :kifu_body="`position sfen ${overlay_question.init_sfen}`"
  //-       :start_turn="0"
  //-       :key_event_capture="false"
  //-       :slider_show="true"
  //-       :controller_show="true"
  //-       :theme="'simple'"
  //-       :size="'default'"
  //-       :sound_effect="true"
  //-       :volume="0.5"
  //-       @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
  //-       )
  //- template(v-else)
  .index_layout
    .primary_header
      .has-text-weight-bold {{current_tab_info.top_nav_name}}
    .secondary_header
      b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
        template(v-for="tab_info in TabInfo.values")
          b-tab-item.is-size-2(:label="tab_info.tab_name")

    template(v-if="current_tab_info.key === 'history_index'")
      the_history_row(v-for="row in history_records" :row="row")

    template(v-if="current_tab_info.key === 'clip_index'")
      the_history_row(v-for="row in clip_records" :row="row")
  debug_print
</template>

<script>
import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "history_index", tab_name: "履歴",       top_nav_name: "問題履歴"        },
      { key: "clip_index",    tab_name: "お気に入り", top_nav_name: "お気に入り問題", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import support from "./support.js"
import the_history_row from "./the_history_row.vue"
import the_history_basic from "./the_history_basic.js"
import the_history_clip from "./the_history_clip.js"

export default {
  name: "the_history",
  mixins: [
    support,
    the_history_basic,
    the_history_clip,
  ],
  components: {
    the_history_row,
  },
  props: {
  },
  data() {
    return {
      tab_index: null,
    }
  },

  created() {
    this.app.lobby_close()

    this.sound_play("click")
    this.mode_select("history_index")
    this.tab_change_handle()
  },

  watch: {
  },

  methods: {
    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    tab_change_handle() {
      this.sound_play("click")
      this[this.current_tab_info.handle_method_name]()
    },

    ////////////////////////////////////////////////////////////////////////////////

    vote_handle(history, vote_key, vote_value) {
      this.sound_play("click")
      if (vote_key === "good") {
        if (vote_value) {
          this.talk("よき", {rate: 1.5})
        }
      } else {
        if (vote_value) {
          this.talk("だめ", {rate: 1.5})
        }
      }
      this.silent_http_command("PUT", this.app.info.put_path, { vote_handle: true, question_id: history.question.id, vote_key: vote_key, vote_value: vote_value, }, e => {
        if (e.retval) {
          this.$set(history, "good_p", e.retval.good_p)
          this.$set(history.question, "good_marks_count", history.question.good_marks_count + e.retval.good_diff)

          this.$set(history, "bad_p", e.retval.bad_p)
          this.$set(history.question, "bad_marks_count", history.question.bad_marks_count + e.retval.bad_diff)
        }
      })
    },

    clip_handle(history, clip_p) {
      this.sound_play("click")
      if (clip_p) {
        this.talk("お気に入り", {rate: 1.5})
      }
      this.silent_http_command("PUT", this.app.info.put_path, { clip_handle: true, question_id: history.question.id, clip_p: clip_p, }, e => {
        if (e.retval) {
          this.$set(history, "clip_p", e.retval.clip_p)
          this.$set(history.question, "clips_count", history.question.clips_count + e.retval.diff)
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
  .index_layout
    @extend %padding_top2
    .main_tabs
      a
        padding-top: 1rem
      .tab-content
        padding: 0
        padding-top: 0
</style>
