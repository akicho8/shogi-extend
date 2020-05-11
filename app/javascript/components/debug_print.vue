<template lang="pug">
.debug_print
  .columns
    .column
      .box
        table(v-if="$parent.$props")
          caption
            | props
          template(v-for="(value, key) in $parent.$props")
            debug_print_value(:dp_key="key" :value="value")

        table(v-if="$parent.$data")
          caption
            | data
          template(v-for="(value, key) in $parent.$data")
            debug_print_value(:dp_key="key" :value="value")

        table(v-if="$parent._computedWatchers")
          caption
            | computed
          template(v-for="(e, key) in $parent._computedWatchers")
            debug_print_value(:dp_key="key" :value="e.value")

        table(v-if="'$store' in this && $store.state")
          caption
            | store
          template(v-for="(value, key) in $store.state")
            debug_print_value(:dp_key="key" :value="value")
</template>

<script>
import debug_print_value from "./debug_print_value"

export default {
  name: "debug_print",
  props: {
    grep: { required: false },
  },
  components: {
    debug_print_value,
  },
  created() {
  },
  methods: {
    show_p(key) {
      if (this.grep) {
        return this.grep.test(key)
      }
      return true
    },
    key_format(key) {
      if (/^[$_]/.test(key)) {
        return `<span class='non_reactive_key'>${key}</span>`
      }
      return key
    },
    value_format(v) {
      if (v === undefined) {
        return "<span class='undefined_value'>undefined</span>"
      }
      if (v === null) {
        return "<span class='null_value'>null</span>"
      }
      try {
        return JSON.stringify(v, null, 4)
      } catch (_) {
        return "<span class='circular_value'>circular</span>"
      }
    },
  },
}
</script>

<style lang="sass">
.debug_print
  .box
    border: 1px solid hsl(0, 0%, 80%)
    overflow-x: scroll

  table
    &:not(:first-child)
      margin-top: 0.75rem

    border-collapse: separate
    border-spacing: 1px
    background: hsl(0, 0%, 80%)
    color: hsl(0, 0%, 10%)

    caption
      font-weight: bold
      text-align: left
    th, td
      padding: 0.2rem 0.5rem
    th
      background: hsl(0, 0%, 95%)
      text-align: right
      .non_reactive_key
        color: hsl(0, 0%, 60%)
    td
      white-space: pre
      background: white
      .undefined_value
        color: hsl(0, 0%, 80%)
      .null_value
        color: hsl(0, 0%, 60%)
      .circular_value
        color: hsl(0, 50%, 50%)
</style>
