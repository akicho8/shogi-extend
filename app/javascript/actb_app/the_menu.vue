<template lang="pug">
.the_menu
  the_footer
  .primary_header
    .header_center_title メニュー

  .menu_buttons
    b-button(expanded @click="app.profile_edit_handle" :disabled="!app.current_user") プロフィール編集
    b-button(expanded tag="a" href="/" @click="sound_play('click')") TOP
</template>

<script>
import { support } from "./support.js"
import { background_grey } from "./background_grey.js"

import the_footer from "./the_footer.vue"

export default {
  name: "the_menu",
  mixins: [
    support,
    background_grey,
  ],
  components: {
    the_footer,
  },
  created() {
    this.app.lobby_unsubscribe()
    this.sound_play("click")
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu
  padding: $padding_top1 0.7rem $margin_bottom
  .menu_buttons
    margin-top: 1rem
    .button
      justify-content: flex-start
      height: 3.75rem
      &:not(:first-child)
        margin-top: 0.3rem // ボタンとボタンの隙間
</style>
