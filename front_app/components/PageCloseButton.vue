<template lang="pug">
.PageCloseButton.is-clickable(v-bind="$attrs" v-on="$listeners" :class="position")
  .delete.is-medium
    slot
</template>

<script>
export default {
  name: "PageCloseButton",
  props: {
    position: { type: String, default: "is_fixed", },
  },
}
</script>

<style lang="sass">
.PageCloseButton
  &.is_absolute
    position: absolute
  &.is_fixed
    position: fixed
  top: 0
  left: 0
  padding: 0.5rem

.STAGE-development
  .PageCloseButton
    border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
