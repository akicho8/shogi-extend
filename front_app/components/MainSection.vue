<template lang="pug">
.MainSection.section
  slot
</template>

<style lang="sass">
.MainSection.section
  +mobile
    padding: 1.2rem 1.0rem
.STAGE-development
  .MainSection.section
    +touch
      border: 2px dashed $primary
    +mobile
      border: 2px dashed $danger
</style>
