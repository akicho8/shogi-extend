<template lang="pug">
//- :permanent_mark_append="item.param_info.permanent"
SimpleRadioButton.SettingInput.field_block(
  :base="SB"
  :model_name="item.param_info.relation || item.param_info.input_attrs"
  :sync_value.sync="SB.$data[item.key]"
  custom-class="is-small"
  element_size="is-small"
  )
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
@import "../sass/support.sass"
</style>
