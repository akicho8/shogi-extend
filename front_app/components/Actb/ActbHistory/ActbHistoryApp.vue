<template lang="pug">
.ActbHistoryApp
  ActbFooter(:base="base")
  .primary_header
    .header_center_title {{base.history_current_tab_info.top_nav_name}}
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="base.history_tab_index" expanded @input="base.history_tab_change_handle")
      template(v-for="tab_info in base.HistoryTabInfo.values")
        b-tab-item(:label="tab_info.tab_name")

  template(v-if="base.history_current_tab_info.key === 'history_index'")
    ActbHistoryRow(:base="base" v-for="row in base.history_records" :row="row")

  template(v-if="base.history_current_tab_info.key === 'clip_index'")
    ActbHistoryRow(:base="base" v-for="row in base.clip_records" :row="row")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbHistoryApp",
  mixins: [
    support_child,
  ],

  created() {
    // this.$ga.event("open", {event_category: "問題履歴"})

    this.base.lobby_unsubscribe()
    this.base.history_mode_select("history_index")
    this.base.history_tab_change_handle()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbHistoryApp
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
