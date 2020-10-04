<template lang="pug">
  b-button.NormalShowButton.is-small(v-bind="$attrs" v-on="$listeners" icon-left="play-circle" @click="click_handle")
    | 詳細
</template>

<script>
export default {
  name: "NormalShowButton",
}
</script>

<style lang="sass">
.NormalShowButton
  font-weight: normal
</style>
