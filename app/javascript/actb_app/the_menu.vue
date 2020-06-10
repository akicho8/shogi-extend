<template lang="pug">
.the_menu
  .primary_header
    .header_center_title メニュー

  .menu_buttons
    b-button(expanded @click="app.profile_edit_handle" :disabled="!app.current_user") プロフィール編集
    b-button(expanded tag="a" href="/" @click="sound_play('click')") TOP
</template>

<script>

import { support } from "./support.js"

export default {
  name: "the_menu",
  mixins: [
    support,
  ],
  created() {
    this.app.lobby_unsubscribe()
    this.sound_play("click")
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu
  @extend %padding_top_for_primary_header
  margin: 1rem 0.7rem $margin_bottom

  .button
    justify-content: flex-start
    height: 3.75rem
    &:not(:first-child)
      margin-top: 0.3rem // ボタンとボタンの隙間
</style>
