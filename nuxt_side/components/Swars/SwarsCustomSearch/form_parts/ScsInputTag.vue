<template lang="pug">
b-field.field_block.ScsInputTag(custom-class="is-small")
  template(#label)
    | {{label}}({{current_tags.length}})
    span.mx-1(class="has-text-grey has-text-weight-normal is-italic is-size-7")
      span.logical_block.mx-1
        template(v-for="e in TheApp.LogicalInfo.values")
          a(@click="op_click_handle(e)" :class="e.css_class(current_op)")
            | {{e.name}}
  b-taginput(
    :size="TheApp.input_element_size"
    v-model="current_tags"
    :data="filtered_tags"
    autocomplete
    open-on-focus
    allow-new
    icon="label"
    placeholder="Add a tag"
    spellcheck="false"
    @typing="typing_handle"
    @add="add_handle"
    @remove="remove_handle"
    max-height="50dvh"
    group-field="name"
    group-options="values"
    expanded
    attached
    :on-paste-separators="[',', ' ']"
    )
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ScsInputTag",
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
    this.typing_handle("") // open-on-focus で open するために最初に作っておく
  },
  methods: {
    typing_handle(text) {
      text = this.$GX.str_normalize_for_ac(text)
      const av = []
      _.each(this.TheApp.xi.tactic_infos, (e, _) => {
        const values = e.values.filter(e => this.$GX.str_normalize_for_ac(e).indexOf(text) >= 0)
        if (values.length >= 1) {
          av.push({name: `── ${e.name} ──`, values: values})
        }
      })
      this.filtered_tags = av
    },
    op_click_handle(e) {
      if (this.current_op !== e.key) {
        this.current_op = e.key
        this.sfx_click()
        this.talk(e.yomiage)
      }
    },
    add_handle(tag) {
      this.sfx_play_toggle(true)
      this.talk(tag)
    },
    remove_handle(tag) {
      this.sfx_play_toggle(false)
    },
  },
  computed: {
    current_tags: {
      set(v) { this.TheApp.$data[this.tags_var] = v    },
      get()  { return this.TheApp.$data[this.tags_var] },
    },
    current_op: {
      set(v) { this.TheApp.$data[this.op_var] = v    },
      get()  { return this.TheApp.$data[this.op_var] },
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ScsInputTag
  .logical_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
