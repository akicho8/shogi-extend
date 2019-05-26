<template lang="pug">
  span
    span(v-text="' '")
    b-icon(:icon="icon" :size="size2")
    span(v-text="' '")
</template>

<script>
export default {
  props: {
    icon: { required: true, },
    size: { default: "is-small", },
  },

  computed: {
    size2() {
      return this.size
      //   === "is-small") {
      //   return "is-small"
      // }
    },
    // customSize2() {
    //   if (this.size === "is-small") {
    //     return null
    //   }
    //   if (this.size === "is-default") {
    //     return "mdi-24px"
    //   }
    //   if (this.size === "is-medium") {
    //     return "mdi-36px"
    //   }
    //   if (this.size === "is-large") {
    //     return "mdi-48px"
    //   }
    // },
  },
}
</script>

<style lang="sass">
// .swars_user_link_to
//   border: 1px solid blue !important
//   background-color: red !important
</style>
