<template lang="pug">
b-field.field_block.ScsInputNumber(custom-class="is-small")
  template(#label)
    | {{label}}
    template(v-if="$gs.present_p(message)")
      span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
        | {{message}}
  b-field(grouped)
    b-switch(v-model="xxx_enabled" @input="switch_handle" :size="TheApp.input_element_size")
    template(v-if="true")
      b-numberinput.ml-2(
        :size="TheApp.input_element_size"
        exponential
        controls-position="compact"
        v-model="xxx_value"
        :min="min"
        :max="max"
        @input="sfx_click()"
        :disabled="!xxx_enabled"
        expanded
        )
      b-select(v-model="xxx_compare" @input="sfx_click()" :disabled="!xxx_enabled" :size="TheApp.input_element_size")
        option(v-for="e in TheApp.CompareInfo.values" :value="e.key") {{e.name}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ScsInputNumber",
  mixins: [
    support_child,
  ],
  props: {
    label:           { type: String, required: true,                },
    message:         { type: String, required: false,               },
    xxx_value_var:   { type: String, required: true,                },
    xxx_enabled_var: { type: String, required: true,                },
    xxx_compare_var: { type: String, required: true,                },
    min:             { type: Number, required: false, default: 0,   },
    max:             { type: Number, required: false, default: 200, },
  },
  methods: {
    switch_handle(v) {
      this.sfx_play_toggle(v)
      if (v) {
        this.talk(this.label)
      }
    },
  },
  computed: {
    xxx_compare: {
      set(v) { this.TheApp.$data[this.xxx_compare_var] = v    },
      get()  { return this.TheApp.$data[this.xxx_compare_var] },
    },
    xxx_enabled: {
      set(v) { this.TheApp.$data[this.xxx_enabled_var] = v    },
      get()  { return this.TheApp.$data[this.xxx_enabled_var] },
    },
    xxx_value: {
      set(v) { this.TheApp.$data[this.xxx_value_var] = v    },
      get()  { return this.TheApp.$data[this.xxx_value_var] },
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ScsInputNumber
  .logical_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
