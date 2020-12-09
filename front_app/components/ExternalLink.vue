<template lang="pug">
components(:is="tag" v-bind="$attrs" v-on="$listeners" :target="target_default" @click="click_handle")
  slot
</template>

<script>
export default {
  name: "NormalLink",
  props: {
    tag:  { type: String,  default: "a",   },
    beep: { type: Boolean, default: false, },
  },
  methods: {
    click_handle() {
      if (this.beep) {
        this.sound_play("click")
      }
    },
  },
}
</script>

<style lang="sass">
.NormalLink
</style>
