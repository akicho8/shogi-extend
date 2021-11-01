<template lang="pug">
.WkbkTagList.buttons(v-if="tag_list.length >= 1")
  b-button(
    v-for="tag in tag_list"
    :key="tag"
    rounded
    size="is-small"
    type="is-primary is-light"
    @click.prevent.stop="tag_search_handle(tag)"
    )
    | {{tag}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "WkbkTagList",
  mixins: [support],
  props: {
    tag_list:          { type: Array,    required: true, },
    tag_search_handle: { type: Function, required: true, },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.WkbkTagList
</style>
