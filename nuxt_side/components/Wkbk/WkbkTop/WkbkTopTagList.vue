<template lang="pug">
.WkbkTopTagList.column.is-12(v-if="$gs.present_p(base.tags)")
  b-taglist.is-clipped
    template(v-for="tag in base.tags")
      b-tag(closable @close="base.tag_remove_handle(tag)" :key="tag")
        | {{tag}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkTopTagList",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopTagList
  display: flex
  justify-content: flex-start
  .tags, .tag
    margin-top: 0
    margin-bottom: 0
</style>
