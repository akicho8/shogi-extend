<template lang="pug">
  b-button.SpShowButton.is-small(v-bind="$attrs" v-on="$listeners" icon-left="play-circle" @click="click_handle")
    | 盤面
</template>

<script>

export default {
  name: "SpShowButton",
  methods: {
    click_handle() {
      // this.$gtag.event("click", {event_category: "プレイヤー情報"})
    },
  },
}
</script>

<style lang="sass">
.SpShowButton
  font-weight: normal
</style>
