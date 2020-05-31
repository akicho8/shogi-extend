<template lang="pug">
.the_history
  .primary_header
    .header_center_title {{current_tab_info.top_nav_name}}
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      template(v-for="tab_info in TabInfo.values")
        b-tab-item.is-size-2(:label="tab_info.tab_name")

  template(v-if="current_tab_info.key === 'history_index'")
    the_history_row(v-for="row in history_records" :row="row")

  template(v-if="current_tab_info.key === 'clip_index'")
    the_history_row(v-for="row in clip_records" :row="row")
</template>

<script>
import MemoryRecord from 'js-memory-record'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "history_index", tab_name: "履歴",       top_nav_name: "問題履歴"    },
      { key: "clip_index",    tab_name: "保存リスト", top_nav_name: "保存リスト", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import { support } from "./support.js"
import the_history_row from "./the_history_row.vue"
import { the_history_basic } from "./the_history_basic.js"
import { the_history_clip } from "./the_history_clip.js"

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
    this.app.lobby_unsubscribe()

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
  @extend %padding_top_for_secondary_header
</style>
