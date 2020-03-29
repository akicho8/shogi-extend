<template lang="pug">
  b-button.sp_show_button.is-small(v-bind="$attrs" v-on="$listeners" icon-left="play-circle")
    | 盤面
</template>

<script>

export default {
  name: "sp_show_button",
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.sp_show_button
  font-weight: normal
</style>
