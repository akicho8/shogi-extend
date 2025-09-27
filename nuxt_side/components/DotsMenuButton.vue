<template lang="pug">
.DotsMenuButton
  b-dropdown(position="is-bottom-left" @click.native="sfx_play_click()")
    b-icon.has-text-grey-light.is-inline-block(slot="trigger" icon="dots-vertical")
    slot
</template>

<script>
export default {
  name: "DotsMenuButton",
}
</script>

<style lang="sass">
.DotsMenuButton
  position: absolute
  top: 0
  right: 0
  .dropdown-trigger
    cursor: pointer
    padding: 0.4rem 0.55rem
.STAGE-development
  .DotsMenuButton
    .dropdown-trigger
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
