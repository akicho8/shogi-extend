<template lang="pug">
.XmovieIndexCardListTag.columns(v-if="base.tags.length >= 1")
  .column
    b-taglist
      template(v-for="tag in base.tags")
        b-tag(closable type="is-primary is-light" @close="base.tag_remove_handle(tag)")
          | {{tag}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieIndexCardListTag",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.XmovieIndexCardListTag
  display: flex
  justify-content: flex-start
  .tags, .tag
    margin-top: 0
    margin-bottom: 0
</style>
