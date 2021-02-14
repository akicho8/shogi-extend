<template lang="pug">
.WkbkTopCardListTag(v-if="tags.length >= 1")
  b-taglist
    template(v-for="tag in tags")
      b-tag(closable @close="base.tag_remove_handle(tag)")
        | {{tag}}
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

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
  margin-top: 0rem
  margin-bottom: 1.25rem

  display: flex
  +mobile
    justify-content: center
  +tablet
    justify-content: flex-start
  .tags, .tag
    margin-bottom: 0.00rem
</style>
