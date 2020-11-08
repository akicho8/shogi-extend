<template lang="pug">
.the_history
  the_footer(:base="base")
  .primary_header
    .header_center_title {{base.history_current_tab_info.top_nav_name}}
  .secondary_header
    b-tabs.tabs_in_secondary(v-model="base.history_tab_index" expanded @input="base.history_tab_change_handle")
      template(v-for="tab_info in base.HistoryTabInfo.values")
        b-tab-item(:label="tab_info.tab_name")

  template(v-if="base.history_current_tab_info.key === 'history_index'")
    the_history_row(:base="base" v-for="row in base.history_records" :row="row")

  template(v-if="base.history_current_tab_info.key === 'clip_index'")
    the_history_row(:base="base" v-for="row in base.clip_records" :row="row")
</template>

<script>
import { support_child } from "../support_child.js"
import the_history_row       from "./the_history_row.vue"
import the_footer            from "../the_footer.vue"

export default {
  name: "the_history",
  mixins: [
    support_child,
  ],
  components: {
    the_history_row,
    the_footer,
  },
  created() {
    this.sound_play("click")

    // this.$ga.event("open", {event_category: "問題履歴"})

    this.base.lobby_unsubscribe()
    this.base.history_mode_select("history_index")
    this.base.history_tab_change_handle()
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_history
  @extend %padding_top_for_secondary_header
  margin-bottom: $margin_bottom
</style>
