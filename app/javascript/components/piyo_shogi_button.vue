<template lang="pug">
  a.button.piyo_shogi_button.is-small(v-bind="$attrs" v-on="$listeners" :target="target" @click="click_handle")
    span.icon
      img.left_icon(:src="piyo_shogi_icon")
    span(v-if="!icon_only")
      | ぴよ将棋
</template>

<script>
import piyo_shogi_icon from "piyo_shogi_icon.png"

export default {
  name: "piyo_shogi_button",
  props: {
    icon_only: { default: false, },
  },
  methods: {
    click_handle() {
      this.$gtag.event("click", {event_category: "ぴよ将棋"})
    },
  },
  computed: {
    piyo_shogi_icon() { return piyo_shogi_icon }, // TODO: Vue.js の重複強制どうにかならんの？

    // モバイルかどうかではなく http なら外部に飛ぶのだから _blank にする
    target() {
      if (false) {
        if (this.piyo_shogi_app_p) {
          return '_self'
        } else {
          return '_blank'
        }
      } else {
        if (this.$attrs.href && this.$attrs.href.match(/^http/)) {
          return "_blank"
        } else {
          return "_self"
        }
      }
    },
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
