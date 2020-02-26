<template lang="pug">
  a.button.piyo_shogi_button.is-small(v-bind="$attrs" v-on="$listeners")
    span.icon
      img.left_icon(:src="piyo_shogi_icon")
    span ぴよ将棋
</template>

<script>
import piyo_shogi_icon from "piyo_shogi_icon.png"

export default {
  name: "piyo_shogi_button",
  computed: {
    piyo_shogi_icon() { return piyo_shogi_icon }, // TODO: Vue.js の重複強制どうにかならんの？
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
@import url('https://fonts.googleapis.com/css?family=M+PLUS+Rounded+1c:700&display=swap')

.piyo_shogi_button
  font-family: 'M PLUS Rounded 1c', sans-serif
  font-weight: 700

  .left_icon
    +icon_rorate_if_button_hover("piyo_shogi_button")

  //////////////////////////////////////// 色も黄色にする
  background-color: $piyo
  border-color: lighten($piyo, 30%)
  &:hover
    border-color: lighten($piyo, 10%)
  span
    color: white
  ////////////////////////////////////////
</style>
