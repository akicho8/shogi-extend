<template lang="pug">
.PageCloseButton
  .delete_wrapper(v-on="$listeners")
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
    padding-left: 0.7rem
    padding-top:  0.7rem
    z-index: 2 // shogi-player の「○手目」のdivより下にあって押せない場合があるため指定する(が、必要なくなっているかもしれない)
</style>
