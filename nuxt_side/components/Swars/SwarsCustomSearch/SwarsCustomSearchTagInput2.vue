<template lang="pug">
b-field.field_block.SwarsCustomSearchTagInput2(:label="label")
  template(#label)
    | {{label}}
    template(v-if="present_p(message)")
      span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
        | {{message}}
  b-field(grouped)
    b-switch(v-model="xxx_enabled" @input="sound_play_toggle")
    template(v-if="true")
      b-numberinput(
        exponential
        controls-position="compact"
        v-model="xxx_value"
        :min="min"
        :max="max"
        @input="sound_play_click()"
        :disabled="!xxx_enabled"
        )
      b-select(v-model="xxx_compare" @input="sound_play_click()" :disabled="!xxx_enabled")
        option(v-for="e in base.CompareInfo.values" :value="e.key") {{e.name}}
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchTagInput2",
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
  data() {
    return {
      // filtered_tags: null, // 干渉しないようにコンポーネントローカルにすること
    }
  },
  created() {
    // this.filtered_tags_rebuild("") // open-on-focus で open するために最初に作っておく
  },
  methods: {
    // filtered_tags_rebuild(text) {
    //   text = this.normalize_for_autocomplete(text)
    //   const av = []
    //   _.each(this.base.xi.tactic_infos, (e, _) => {
    //     const values = e.values.filter(e => this.normalize_for_autocomplete(e).indexOf(text) >= 0)
    //     if (values.length >= 1) {
    //       av.push({name: `── ${e.name} ──`, values: values})
    //     }
    //   })
    //   this.filtered_tags = av
    // },
    // op_click_handle(e) {
    //   if (this.current_op !== e.key) {
    //     this.current_op = e.key
    //     this.sound_play_click()
    //     this.talk(e.yomiage)
    //   }
    // },
    // add_handle(e) {
    //   this.sound_play_toggle(true)
    //   this.talk(e)
    // },
    // remove_handle(e) {
    //   this.sound_play_toggle(false)
    // },
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
.SwarsCustomSearchTagInput2
  .logical_block
    a:not(:first-child)
      margin-left: 0.25em
</style>
