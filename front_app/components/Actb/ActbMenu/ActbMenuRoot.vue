<template lang="pug">
.ActbMenuRoot
  .primary_header
    .header_center_title メニュー
  .menu_buttons
    b-button(expanded tag="nuxt-link" :to="{name: 'settings-profile'}" :disabled="!base.current_user" @click.native="sound_play('click')") プロフィール
    b-button(expanded @click="base.emotion_index_handle" :disabled="!base.current_user" v-if="base.config.emotion_editable_p") エモーション
    b-button(expanded tag="a" :href="question_zip_download_url" @click="sound_play('click')" :disabled="!base.current_user" v-if="development_p") 問題ダウンロード(直接)
    b-button(expanded @click="zip_dl_count_fetch" :disabled="!base.current_user") 問題ダウンロード
    b-button(expanded @click="base.menu_to('ActbMenuEtc')" ) その他
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbMenuRoot",
  mixins: [
    support_child,
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
      const url = new URL(this.$config.MY_SITE_URL + "/api/actb")
      url.searchParams.set("remote_action", "question_download")
      url.searchParams.set("format", "zip")
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbMenuRoot
</style>
