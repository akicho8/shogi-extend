<template lang="pug">
//- $PiyoShogiTypeCurrent.info.showable_p が client でしか動かないため必ず client-only 配下に入れること
client-only
  a.button.PiyoShogiButton.is-small(
    v-if="$PiyoShogiTypeCurrent.info.showable_p || $config.STAGE === 'development'"
    :title="piyo_shogi_name"
    v-bind="$attrs"
    v-on="$listeners"
    :target="target_default"
    @click="click_handle"
    )
    span.icon
      img.icon_left(src="~/assets/piyo_shogi_icon.png")
    span(v-if="label_p")
      | {{piyo_shogi_name}}
</template>

<script>
export default {
  name: "PiyoShogiButton",
  props: {
    label_p: { default: true, },
  },
  methods: {
    click_handle() {
      this.app_log("ぴよ将棋起動")
    },
  },
  computed: {
    piyo_shogi_name() { return "ぴよ将棋" },
  },
}
</script>

<style lang="sass">
.PiyoShogiButton
  font-weight: bold

  .icon_left
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
