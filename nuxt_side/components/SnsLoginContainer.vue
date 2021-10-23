<template lang="pug">
.card.SnsLoginContainer
  .card-content
    .is-flex.is-justify-content-center.is-flex-direction-column
      template(v-for="e in SocialMediaInfo.values")
        b-button.has-text-weight-bold(rounded :type="`is-${e.key}`" :icon-left="e.key" @click="click_handle(e)")
          span {{e.name}} でログインする
      template(v-if="true")
        b-button.has-text-weight-bold(rounded type="is-primary"  @click="passowrd_login_click_handle(e)")
          span パスワードでログインする
</template>

<script>
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

class SocialMediaInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "twitter", name: "Twitter", },
      { key: "google",  name: "Google",  },
      { key: "github",  name: "GitHub",  },
    ]
  }
}

export default {
  name: "SnsLoginContainer",
  methods: {
    click_handle(e) {
      this.sound_play_click()
      this.$emit("close")
      this.$buefy.loading.open()
      // 「Not found. Authentication passthru.」対策
      // https://zenn.dev/koshilife/articles/b71f8cfcb50e33
      // ../../config/initializers/0290_omnauth.rb でGETを許可してあるので通る
      // 本当はPOSTしないといけない
      location.href = this.sns_auth_url(e)
    },
    sns_auth_url(e) {
      return this.login_url_build({social_media_key: e.key})
    },
    passowrd_login_click_handle() {
      this.sound_play_click()
      this.$emit("close")
      this.login_url_jump()
    },
  },
  computed: {
    SocialMediaInfo() { return SocialMediaInfo },
  },
}
</script>

<style lang="sass">
.SnsLoginContainer
  .button:not(:first-child)
    margin-top: 0.9rem
</style>
