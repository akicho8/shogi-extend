<template lang="pug">
  b-button.kif_copy_button.is-small(v-bind="$attrs" v-on="$listeners" icon-left="clipboard-plus-outline")
    | コピー
</template>

<script>

export default {
  name: "kif_copy_button",
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.kif_copy_button
  font-weight: normal
</style>
