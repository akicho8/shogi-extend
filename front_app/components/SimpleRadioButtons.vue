<template lang="pug">
b-field(:label="model.field_label" :message="model.fetch(base[var_name]).message || model.field_message")
  template(v-for="e in model.values")
    b-radio-button(@input="sound_play('click')" v-model="base[var_name]" :native-value="e.key" :type="e.type")
      | {{e.name}}
</template>

<script>
export default {
  name: "SimpleRadioButtons",
  props: {
    model:    { type: Object, required: true, },
    base:     { type: Object, required: true, },
    var_name: { type: String, required: true, },
  },
}
</script>

<style lang="sass">
</style>
