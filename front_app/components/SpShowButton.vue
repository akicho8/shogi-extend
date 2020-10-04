<template lang="pug">
  b-button.SpShowButton.is-small(v-bind="$attrs" v-on="$listeners" icon-left="play-circle" @click="click_handle")
    | 詳細
</template>

<script>
export default {
  name: "SpShowButton",
}
</script>

<style lang="sass">
.SpShowButton
  font-weight: normal
</style>
