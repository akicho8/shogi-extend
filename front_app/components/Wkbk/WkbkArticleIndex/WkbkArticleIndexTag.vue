<template lang="pug">
.WkbkArticleIndexTag(v-if="base.tag")
  b-tag(attached closable @close="base.tag_search_handle(null)" type="is-primary")
    | {{base.tag}}
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkArticleIndexTag",
  mixins: [support_child],
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
