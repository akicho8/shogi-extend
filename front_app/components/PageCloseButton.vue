<template lang="pug">
.PageCloseButton.delete.is-medium.is-clickable(v-bind="$attrs" v-on="$listeners" :class="position")
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
  top: 0.6rem
  left: 0.6rem

.STAGE-development
  .PageCloseButton
    .delete
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
