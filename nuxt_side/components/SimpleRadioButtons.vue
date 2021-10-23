<template lang="pug">
b-field(:label="real_model.field_label" :message="current.message || real_model.field_message")
  template(v-for="e in real_model.values")
    b-radio-button(
      v-if="e.environment == null || e.environment.includes($config.STAGE)"
      :class="e.key"
      @input="click_handle"
      v-model="base[var_name]"
      :native-value="e.key"
      :type="e.type"
      v-on="$listeners"
      )
      | {{e.name}}
</template>

<script>
export default {
  name: "SimpleRadioButtons",
  props: {
    base:       { type: Object, required: true, },
    model_name: { type: String, required: true, },
    var_name:   { type: String, required: true, },
  },
  methods: {
    click_handle(e) {
      this.sound_play_click()
      this.talk(this.current.name)
    },
  },
  computed: {
    real_model() { return this.base[this.model_name]             },
    real_value() { return this.base[this.var_name]               },
    current()    { return this.real_model.fetch(this.real_value) },
  },
}
</script>

<style lang="sass">
</style>
