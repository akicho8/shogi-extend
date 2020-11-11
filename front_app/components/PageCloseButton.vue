<template lang="pug">
.PageCloseButton
  .delete_wrapper.is-clickable(v-on="$listeners")
    .delete.is-medium(v-bind="$attrs")
      slot
</template>

<script>
export default {
  name: "PageCloseButton",
}
</script>

<style lang="sass">
.PageCloseButton
  position: absolute
  top: 0
  left: 0
  .delete_wrapper
    padding: 0.6rem

.STAGE-development
  .PageCloseButton
    .delete_wrapper
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
