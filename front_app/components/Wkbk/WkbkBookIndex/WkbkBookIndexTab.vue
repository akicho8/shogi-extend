<template lang="pug">
b-tabs.WkbkBookIndexTab.mb-0(v-model="base.tab_index" expanded @input="base.tab_input_handle")
  template(v-for="e in base.IndexScopeInfo.values")
    b-tab-item
      template(slot="header")
        span
          | {{e.name}}
          b-tag(rounded)
            | {{base.count_in_tab(e)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookIndexTab",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexTab
  .tab-content
    display: none
</style>
