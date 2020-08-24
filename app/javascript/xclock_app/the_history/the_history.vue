<template lang="pug">
.the_history
  the_footer
  .primary_header
    .header_center_title {{app.history_current_tab_info.top_nav_name}}
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="app.history_tab_index" expanded @change="app.history_tab_change_handle")
      template(v-for="tab_info in app.HistoryTabInfo.values")
        b-tab-item(:label="tab_info.tab_name")

  template(v-if="app.history_current_tab_info.key === 'history_index'")
    the_history_row(v-for="row in app.history_records" :row="row")

  template(v-if="app.history_current_tab_info.key === 'clip_index'")
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

    this.$gtag.event("open", {event_category: "問題履歴"})

    this.app.lobby_unsubscribe()
    this.app.history_mode_select("history_index")
    this.app.history_tab_change_handle()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_history
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
