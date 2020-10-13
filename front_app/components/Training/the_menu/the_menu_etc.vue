<template lang="pug">
.the_menu_etc
  .primary_header
    .header_center_title その他
  .menu_buttons
    b-button(expanded @click="app.menu_to('the_menu_debug')" type="is-danger" v-if="permit_staff_p") デバッグモード
    b-button(expanded tag="a" href="/" @click="sound_play('click')") TOP
    b-button(expanded @click="app.menu_to('the_menu_root')") もどる
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_menu_etc",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
.the_menu_etc
</style>
