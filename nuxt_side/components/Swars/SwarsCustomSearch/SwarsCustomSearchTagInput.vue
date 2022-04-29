<template lang="pug">
b-field.field_block.SwarsCustomSearchTagInput
  template(#label)
    | {{label}}
    span.mx-1(class="has-text-grey has-text-weight-normal is-italic is-size-7")
      span.logical_block.mx-1
        template(v-for="e in base.LogicalInfo.values")
          a(@click="op_click_handle(e)" :class="e.css_class(current_op)")
            | {{e.name}}
      | を含む
  b-taginput(
    v-model="base.$data[tags_var]"
    :data="filtered_tags"
    autocomplete
    open-on-focus
    allow-new
    icon="label"
    placeholder="Add a tag"
    @typing="filtered_tags_rebuild"
    @add="add_handle"
    @remove="remove_handle"
    max-height="50vh"
    group-field="name"
    group-options="values"
    expanded
    :on-paste-separators="[',', ' ']"
    )
</template>

<script>
import _ from "lodash"
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
  data() {
    return {
      filtered_tags: null, // 干渉しないようにコンポーネントローカルにすること
    }
  },
  created() {
    this.filtered_tags_rebuild("") // open-on-focus で open するために最初に作っておく
  },
  methods: {
    filtered_tags_rebuild(text) {
      text = this.normalize_for_autocomplete(text)
      const av = []
      _.each(this.base.xi.tactic_infos, (e, _) => {
        const values = e.values.filter(e => this.normalize_for_autocomplete(e).indexOf(text) >= 0)
        if (values.length >= 1) {
          av.push({name: `── ${e.name} ──`, values: values})
        }
      })
      this.filtered_tags = av
    },
    op_click_handle(e) {
      if (this.current_op !== e.key) {
        this.current_op = e.key
        this.sound_play_click()
        this.talk(e.yomiage)
      }
    },
    add_handle(e) {
      this.sound_play_toggle(true)
      this.talk(e)
    },
    remove_handle(e) {
      this.sound_play_toggle(false)
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
  .logical_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
