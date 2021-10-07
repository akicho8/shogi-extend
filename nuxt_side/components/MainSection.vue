<template lang="pug">
.MainSection.section
  slot
</template>

<style lang="sass">
.MainSection.section
  +mobile
    padding: 1.0rem 0.75rem
    &.is_mobile_padding_zero
      padding: 0

    // is-fluid 付きの container は mobile のときも左右の padding が入ったままになっているため取る
    .container.is-fluid
      padding-left: unset
      padding-right: unset

.STAGE-development
  .MainSection.section
    +mobile
      border: 1px dashed $danger
    +tablet
      border: 1px dashed $primary
</style>
