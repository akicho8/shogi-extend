<template lang="pug">
.the_history
  the_footer
  .primary_header
    .header_center_title {{app.current_tab_info2.top_nav_name}}
  .secondary_header
    b-tabs.main_tabs(v-model="app.tab_index2" expanded @change="app.tab_change_handle2")
      template(v-for="tab_info in app.TabInfo2.values")
        b-tab-item(:label="tab_info.tab_name")

  template(v-if="app.current_tab_info2.key === 'history_index'")
    the_history_row(v-for="row in app.history_records" :row="row")

  template(v-if="app.current_tab_info2.key === 'clip_index'")
    the_history_row(v-for="row in app.clip_records" :row="row")
</template>

<script>
import { support } from "../support.js"
import the_history_row       from "./the_history_row.vue"
import the_footer            from "../the_footer.vue"

export default {
  name: "the_history",
  mixins: [
    support,
  ],
  components: {
    the_history_row,
    the_footer,
  },
  created() {
    this.sound_play("click")

    this.app.lobby_unsubscribe()
    this.app.mode_select2("history_index")
    this.app.tab_change_handle2()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_history
  @extend %padding_top_for_secondary_header
</style>
