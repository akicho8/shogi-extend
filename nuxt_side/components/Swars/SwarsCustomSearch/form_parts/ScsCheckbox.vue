<template lang="pug">
b-field.field_block.is_scroll_x.ScsCheckbox(custom-class="is-small" :label="label1")
  template(v-for="e in records")
    b-checkbox-button(
      :size="TheApp.input_element_size"
      expanded
      v-model="TheApp.$data[var_name]"
      :native-value="e.key"
      @input="av => checked_handle(av, e)"
      )
      | {{e.name || e.key}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ScsCheckbox",
  mixins: [
    support_child,
  ],
  props: {
    records:    { type: Array, required: true, },
    var_name:   { type: String, required: true, },
    label1:     { type: String, required: true, },
    // label2:   { type: String, required: true, },
    last_only_if_full: { type: Boolean, default: false }, // すべてが押されたら最後の1つだけにするか？
  },
  methods: {
    checked_handle(av, e) {
      const on = av.includes(e.key)
      this.sfx_play_toggle(on)
      if (on) {
        this.talk(e.yomiage ?? e.name ?? e.key)

        if (this.last_only_if_full) {
          if (this.records.every(e => av.includes(e.key))) {
            this.TheApp.$data[this.var_name] = [e.key]
          }
        }
      }
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ScsCheckbox
  __css_keep__: 0
</style>
