<template lang="pug">
.buttons.KiwiTagList(v-if="$GX.present_p(tag_list)")
  b-button(
    v-for="tag in tag_list"
    :key="tag"
    rounded
    size="is-small"
    @click.prevent.stop="tag_click_handle(tag)"
    )
    | {{tag}}
    //- type="is-primary is-light"

//- b-taglist.KiwiTagList(v-if="$GX.present_p(tag_list)")
//-   b-tag.is-clickable(
//-     v-for="tag in tag_list"
//-     :key="tag"
//-     rounded
//-     size="is-small"
//-     @click.native.prevent.stop="tag_click_handle(tag)"
//-     )
//-     | {{tag}}
//-     //- type="is-primary is-light"

</template>

<script>
import { all_support } from "./all_support.js"

export default {
  name: "KiwiTagList",
  mixins: [all_support],
  props: {
    tag_list:          { type: Array,    required: true, },
    tag_click_handle: { type: Function, required: true, },
  },
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiTagList
  __css_keep__: 0
</style>
