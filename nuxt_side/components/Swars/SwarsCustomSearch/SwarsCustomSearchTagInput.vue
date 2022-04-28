<template lang="pug">
b-field.field_block.SwarsCustomSearchTagInput(v-if="base.xi")
  template(#label)
    | {{label1}}
    span.ml-1(class="has-text-grey has-text-weight-normal is-italic is-size-7") {{label2}}
  b-taginput(
    v-model="base.$data[var_name]"
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
    //- type="is-primary"
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchTagInput",
  mixins: [
    support_child,
  ],
  props: {
    var_name: { type: String, required: true, },
    label1:   { type: String, required: true, },
    label2:   { type: String, required: true, },
  },
  methods: {
  },
  computed: {
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchTagInput
</style>
