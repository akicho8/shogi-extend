<template lang="pug">
.debug_print
  .columns
    .column
      .box
        table
          caption
            | props
          tr(v-for="(value, key) in $parent.$props")
            th(v-html="key")
            td(v-html="value_format(value)")

        table
          caption
            | data
          tr(v-for="(value, key) in $parent.$data")
            th(v-html="key")
            td(v-html="value_format(value)")

        table
          caption
            | computed
          tr(v-for="(e, key) in $parent._computedWatchers")
            th(v-html="key")
            td(v-html="value_format(e.value)")

        template(v-if="'$store' in this")
          table
            caption
              | $store
            tr(v-for="(value, key) in $store.state")
              th(v-html="key")
              td(v-html="value_format(value)")
</template>

<script>
export default {
  name: "debug_print",
  props: {
  },
  methods: {
    value_format(v) {
      if (v === undefined) {
        return "<span class='undefined_value'>undefined</span>"
      }
      return JSON.stringify(v, null, 4)
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
    td
      white-space: pre
      background: white
      .undefined_value
        color: hsl(0, 0%, 70%)
</style>
