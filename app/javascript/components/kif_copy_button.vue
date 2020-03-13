<template lang="pug">
  b-button.kif_copy_button.is-small(v-bind="$attrs" v-on="$listeners" icon-left="clipboard-plus-outline")
    template(v-if="!icon_only")
      | コピー
</template>

<script>

export default {
  name: "kif_copy_button",
  props: {
    icon_only: { default: false, },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.kif_copy_button
  font-weight: normal
</style>
