<template lang="pug">
  b-button.sp_modal_button.is-small(v-bind="$attrs" v-on="$listeners" icon-left="play-circle")
    | 盤面
</template>

<script>

export default {
  name: "sp_modal_button",
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.sp_modal_button
  font-weight: normal
</style>
