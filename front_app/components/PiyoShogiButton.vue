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
      this.ga_click("ぴよ将棋")
    },
  },
  watch: {
    "$attrs.href": function(v) {
    }
  },
  computed: {
    // 「ぴよ将棋w」に飛ぼうとしている？
    web_version_p() {
      return (this.$attrs.href && this.$attrs.href.includes("https://www.studiok-i.net/ps/")) || !this.piyo_shogi_app_p
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
