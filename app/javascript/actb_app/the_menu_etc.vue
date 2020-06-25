<template lang="pug">
.the_menu_etc
  .primary_header
    .header_center_title その他
  .menu_buttons
    b-button(expanded tag="a" :href="question_download_url" @click="sound_play('click')") 棋譜ダウンロード
    b-button(expanded tag="a" href="/" @click="sound_play('click')") トップにもどる
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_menu_etc",
  mixins: [
    support,
  ],
  computed: {
    question_download_url() {
      const url = new URL(location)
      url.searchParams.set("command", "question_download")
      url.searchParams.set("format", "zip")
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_menu_etc
</style>
