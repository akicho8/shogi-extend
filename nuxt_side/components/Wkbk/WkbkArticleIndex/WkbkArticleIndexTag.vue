<template lang="pug">
.WkbkArticleIndexTag(v-if="tags.length >= 1")
  b-taglist
    template(v-for="tag in tags")
      b-tag(closable @close="base.tag_remove_handle(tag)")
        | {{tag}}
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "WkbkArticleIndexTag",
  mixins: [support_child],
  computed: {
    tags() {
      return this.$GX.str_to_tags(this.base.tag)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexTag
  display: flex
  justify-content: center
  align-items: center
  margin-top: 1rem
  margin-bottom: 0.5rem
</style>
