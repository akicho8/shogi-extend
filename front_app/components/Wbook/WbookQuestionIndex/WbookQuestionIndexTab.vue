<template lang="pug">
b-tabs.WbookQuestionIndexTab.mb-0(v-model="base.tab_index" expanded @input="base.tab_change_handle")
  template(v-for="e in base.IndexTabInfo.values")
    b-tab-item(v-if="base.question_tab_available_p(e)")
      template(slot="header")
        span
          | {{e.name}}
          b-tag(rounded)
            | {{base.question_count_in_tab(e)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookQuestionIndexTab",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookQuestionIndexTab
  .tab-content
    display: none
</style>
