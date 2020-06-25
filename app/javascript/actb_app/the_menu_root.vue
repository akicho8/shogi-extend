<template lang="pug">
.the_menu_root
  .primary_header
    .header_center_title メニュー
  .menu_buttons
    b-button(expanded @click="app.profile_edit_handle" :disabled="!app.current_user") プロフィール編集
    b-button(expanded @click="app.menu_to('the_menu_etc')") その他
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_menu_root",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu_root
</style>
