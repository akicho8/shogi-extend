<template lang="pug">
b-field.SimpleSlider(custom-class="is-small" :label="label" :message="message")
  b-slider(v-bind="slider_attrs" v-model="base[var_name]" v-on="$listeners")
</template>

<script>
export default {
  name: "SimpleSlider",
  props: {
    base:     { type: Object, required: true, },
    var_name: { type: String, required: true, },
    label:    { type: String, required: true, },
    message:  { type: String, required: false, },
  },
  computed: {
    slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
        ...this.$attrs,
      }
    },
  },
}
</script>

<style lang="sass">
.SimpleSlider
  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 10px 6px
        font-size: 10px
</style>
