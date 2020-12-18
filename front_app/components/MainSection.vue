<template lang="pug">
.MainSection.section
  slot
</template>

<style lang="sass">
.MainSection.section
  +mobile
    padding: 1.0rem 0.8rem
.STAGE-development
  .MainSection.section
    +mobile
      border: 1px dashed $danger
    +tablet
      border: 1px dashed $primary
</style>
