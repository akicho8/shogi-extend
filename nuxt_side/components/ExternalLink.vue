<template lang="pug">
component(:is="tag" v-bind="$attrs" v-on="$listeners" :target="target_default" @click="click_handle")
  slot
</template>

<script>
export default {
  name: "ExternalLink",
  props: {
    tag:  { type: String,  default: "a",   },
    beep: { type: Boolean, default: false, },
  },
  methods: {
    click_handle() {
      if (this.beep) {
        this.sfx_play_click()
      }
    },
  },
}
</script>

<style lang="sass">
.ExternalLink
  __css_keep__: 0
</style>
