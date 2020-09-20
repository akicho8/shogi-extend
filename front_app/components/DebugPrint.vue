<template lang="pug">
.DebugPrint(v-if="true")
  template(v-if="vars")
    table
      template(v-for="var_name in vars")
        tr
          th(v-html="var_name")
          td(v-html="parent_eval(var_name)")

  template(v-else)
    table(v-if="$parent.$props")
      caption
        | props
      template(v-for="(value, key) in $parent.$props")
        DebugPrintValue(:dp_key="key" :value="value")

    table(v-if="$parent.$data")
      caption
        | data
      template(v-for="(value, key) in $parent.$data")
        DebugPrintValue(:dp_key="key" :value="value")

    table(v-if="$parent._computedWatchers")
      caption
        | computed
      template(v-for="(e, key) in $parent._computedWatchers")
        DebugPrintValue(:dp_key="key" :value="e.value")

    table(v-if="'$store' in this && $store.state")
      caption
        | store
      template(v-for="(value, key) in $store.state")
        DebugPrintValue(:dp_key="key" :value="value")
</template>

<script>
export default {
  name: "DebugPrint",

  props: {
    grep:    { required: false },
    grep_v:  { required: false },
    vars:    { required: false },
    oneline: { default: false  },
  },

  methods: {
    show_p(key) {
      if (this.grep) {
        return this.grep.test(key)
      }
      if (this.grep_v) {
        return !this.grep_v.test(key)
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
      if (typeof(v) === "string") {
        if (/^data:/.test(v)) {
          v = this.truncate(v, 80)
        }
      }
      let sv = null
      try {
        if (this.oneline) {
          sv = JSON.stringify(v)
        } else {
          sv = JSON.stringify(v, null, 4)
        }
      } catch (_) {
        return "<span class='circular_value'>circular</span>"
      }
      return sv
    },

    parent_eval(var_name) {
      const v = eval(`this.$parent.${var_name}`)
      return this.value_format(v)
    },

    truncate(str, len) {
      if (str.length <= len) {
        return str
      } else {
        return str.substr(0, len) + "..."
      }
    },
  },
}
</script>

<style lang="sass">
.DebugPrint
  overflow-x: scroll
  font-size: 0.75rem

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
