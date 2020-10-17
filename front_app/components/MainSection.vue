<template lang="pug">
.MainSection.section
  slot
</template>

<script>
export default {
  name: "MainSection",
}
</script>

<style lang="sass">
.MainSection.section
  +mobile
    padding: 1.4rem 1.2rem
.STAGE-development
  .MainSection.section
    +touch
      border: 1px dashed $primary
    +mobile
      border: 1px dashed $danger
</style>
