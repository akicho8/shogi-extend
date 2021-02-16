<template lang="pug">
.WkbkTopCardListTag.columns(v-if="tags.length >= 1")
  .column
    b-taglist
      template(v-for="tag in tags")
        b-tag(closable @close="base.tag_remove_handle(tag)")
          | {{tag}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkTopCardListTag",
  mixins: [support_child],
  computed: {
    tags() {
      return this.tags_wrap(this.base.tag)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopCardListTag
  display: flex
  justify-content: flex-start
  .tags, .tag
    margin-top: 0
    margin-bottom: 0
</style>
