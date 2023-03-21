<template lang="pug">
.MyApp
  | {{a}}
</template>

<script>
export default {
  data() {
    return {
      a: null,
    }
  },
  mounted() {
    this.a ||= "ok"
  },
}
</script>

<style lang="sass">
.MyApp
  color: blue
  .foo
</style>
