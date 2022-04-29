<template lang="pug">
b-field.field_block.SwarsCustomSearchTagInput(v-if="base.xi")
  template(#label)
    | {{label}}
    span.mx-1(class="has-text-grey has-text-weight-normal is-italic is-size-7")
      span.logicalop_block.mx-1
        template(v-for="e in base.LogicalopInfo.values")
          a(@click="op_click_handle(e)" :class="e.css_class(current_op)")
            | {{e.name}}
      | 含む
  b-taginput(
    v-model="base.$data[tags_var]"
    :data="base.filtered_tags"
    autocomplete
    open-on-focus
    allow-new
    icon="label"
    placeholder="Add a tag"
    @typing="base.filtered_tags_rebuild"
    max-height="50vh"
    group-field="name"
    group-options="values"
    expanded
    :on-paste-separators="[',', ' ']"
    :confirm-keys="[',', 'Tab', 'Enter']"
    )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchTagInput",
  mixins: [
    support_child,
  ],
  props: {
    label:    { type: String, required: true, },
    tags_var: { type: String, required: true, },
    op_var:   { type: String, required: true, },
  },
  methods: {
    op_click_handle(e) {
      if (this.current_op !== e.key) {
        this.current_op = e.key
        this.sound_play_click()
      }
    },
  },
  computed: {
    current_op: {
      set(v) { this.base.$data[this.op_var] = v    },
      get()  { return this.base.$data[this.op_var] },
    },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchTagInput
  .logicalop_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
