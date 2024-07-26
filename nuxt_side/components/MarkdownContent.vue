<template lang="pug">
component(
  v-if="transformed_html"
  :is="component"
  class="MarkdownContent",
  v-bind="$attrs"
  v-on="$listeners"
  v-html="transformed_html"
  )
</template>

<script>
export default {
  name: "MarkdownContent",
  props: {
    component: { type: String, default: "div", },
    body:      { type: String, default: null,  },
  },
  computed: {
    transformed_html() {
      if (this.body) {
        return this.$marked(this.body)
      }
    },
  },
}
</script>

<style lang="sass">
.MarkdownContent
  __css_keep__: 0
</style>
