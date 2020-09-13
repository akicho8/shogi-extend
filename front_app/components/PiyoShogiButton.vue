<template lang="pug">
  a.button.PiyoShogiButton.is-small(v-bind="$attrs" v-on="$listeners" :target="target_default" @click="click_handle")
    span.icon
      img.left_icon(src="~/assets/piyo_shogi_icon.png")
    span(v-if="!icon_only")
      | ぴよ将棋
      span(v-if="web_version_p") ｗ
</template>

<script>

export default {
  name: "PiyoShogiButton",
  props: {
    icon_only: { default: false, },
  },
  methods: {
    click_handle() {
      // this.$gtag.event("click", {event_category: "ぴよ将棋"})
    },
  },
  computed: {
    // 「ぴよ将棋w」に飛ぼうとしている？
    web_version_p() {
      return this.$attrs.href && this.$attrs.href.includes("https://www.studiok-i.net/ps/")
    },
  },
}
</script>

<style lang="sass">
@import url("https://fonts.googleapis.com/css?family=M+PLUS+Rounded+1c:700&display=swap")

.PiyoShogiButton
  font-family: "M PLUS Rounded 1c", sans-serif
  font-weight: 700

  .left_icon
    +icon_rorate_if_button_hover("PiyoShogiButton")

  //////////////////////////////////////// 色も黄色にする
  background-color: $piyo
  border-color: lighten($piyo, 30%)
  &:hover
    border-color: lighten($piyo, 10%)
  span
    color: white
  ////////////////////////////////////////
</style>
