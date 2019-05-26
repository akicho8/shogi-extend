<template lang="pug">
  b-icon(:icon="icon" :customSize="real_size")
</template>

<script>
export default {
  props: {
    icon: { required: true, },
    size: { default: "is-default", },
  },

  computed: {
    real_size() {
      if (this.size === "is-small") {
        return ""
      }
      if (this.size === "is-default") {
        return "mdi-18px"
      }
      if (this.size === "is-medium") {
        return "mdi-24px"
      }
      if (this.size === "is-large") {
        return "mdi-36px"
      }
    },
  },
}
</script>

<style lang="sass">
// .swars_user_link_to
//   border: 1px solid blue !important
//   background-color: red !important
</style>
