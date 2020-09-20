<template lang="pug">
.the_menu_root
  .primary_header
    .header_center_title メニュー
  .menu_buttons
    b-button(expanded @click="app.profile_edit_handle" :disabled="!app.current_user") プロフィール
    b-button(expanded @click="app.emotion_index_handle" :disabled="!app.current_user" v-if="app.config.emotion_editable_p") エモーション
    b-button(expanded tag="a" :href="question_zip_download_url" @click="sound_play('click')" :disabled="!app.current_user" v-if="development_p") 問題ダウンロード(直接)
    b-button(expanded @click="zip_dl_count_fetch" :disabled="!app.current_user") 問題ダウンロード
    b-button(expanded @click="app.menu_to('the_menu_etc')" ) その他
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_menu_root",
  mixins: [
    support,
  ],
  methods: {
    zip_dl_count_fetch() {
      this.api_get("zip_dl_count_fetch", {}, e => {
        if (e.count === 0) {
          this.warning_notice("まだ問題を投稿していません")
          return
        }
        this.ok_notice(`${e.count}件の問題が入ったZIPファイルをダウンロードしました`)
        location.href = this.question_zip_download_url
      })
    },
  },
  computed: {
    question_zip_download_url() {
      const url = new URL(location)
      url.searchParams.set("remote_action", "question_download")
      url.searchParams.set("format", "zip")
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_menu_root
</style>
