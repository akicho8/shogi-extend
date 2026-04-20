<template lang="pug">
b-field.field_block.SettingButton(custom-class="is-small")
  p.control
    b-button(@click="() => SB[item.click_handle]()" size="is-small")
      | {{item.button_name}}
  template(#label)
    span {{item.label}}
  template(#message)
    p(v-html="item.field_message")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SettingInput",
  mixins: [support_child],
  props: {
    item: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "../scss/support"
</style>
