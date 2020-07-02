<template lang="pug">
.the_menu_etc
  .primary_header
    .header_center_title その他
  .menu_buttons
    b-button(expanded @click="app.menu_to('the_menu_sound')") サウンドテスト
    b-button(expanded @click="app.menu_to('the_menu_system')") システム設定
    b-button(expanded @click="app.menu_to('the_menu_root')") もどる
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_menu_etc",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu_etc
</style>
