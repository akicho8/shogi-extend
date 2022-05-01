<template lang="pug">
b-field.field_block.SwarsCustomSearchInputNumber(custom-class="is-small" :label="label")
  template(#label)
    | {{label}}
    template(v-if="present_p(message)")
      span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
        | {{message}}
  b-field(grouped)
    b-switch(size="is-small" v-model="xxx_enabled" @input="sound_play_toggle")
    template(v-if="true")
      b-numberinput.ml-2(
        size="is-small"
        exponential
        controls-position="compact"
        v-model="xxx_value"
        :min="min"
        :max="max"
        @input="sound_play_click()"
        :disabled="!xxx_enabled"
        expanded
        )
      b-select(size="is-small" v-model="xxx_compare" @input="sound_play_click()" :disabled="!xxx_enabled")
        option(v-for="e in base.CompareInfo.values" :value="e.key") {{e.name}}
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchInputNumber",
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
  computed: {
    xxx_compare: {
      set(v) { this.base.$data[this.xxx_compare_var] = v    },
      get()  { return this.base.$data[this.xxx_compare_var] },
    },
    xxx_enabled: {
      set(v) { this.base.$data[this.xxx_enabled_var] = v    },
      get()  { return this.base.$data[this.xxx_enabled_var] },
    },
    xxx_value: {
      set(v) { this.base.$data[this.xxx_value_var] = v    },
      get()  { return this.base.$data[this.xxx_value_var] },
    },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchInputNumber
  .logical_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
