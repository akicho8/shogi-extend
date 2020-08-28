<template lang="pug">
.vs-clock
  xclock
</template>

<script>
// import xclock from "~/components/xclock.vue"
import xclock from "~/components/xclock_app/app.vue"

export default {
  name: "xclock_app",
  components: {
    xclock,
  },
}
</script>

<style lang="sass">
</style>
