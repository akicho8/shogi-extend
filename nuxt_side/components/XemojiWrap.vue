<template lang="pug">
.XemojiWrap(:is="component" v-xemoji :key="str" v-html="str" v-bind="$attrs" v-on="$listeners")
</template>

<script>
export default {
  name: "XemojiWrap",
  props: {
    component: { type: String, required: false, default: "span", },
    str:       { type: String, required: false, default: "",     },
  },
}
</script>

<style lang="sass">
.STAGE-development
  .XemojiWrap
    // background-color: change_color($primary, $alpha: 0.1)
</style>
