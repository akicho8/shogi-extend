<template lang="pug">
client-only
  .SwarsUserKeyKentoApi.has-background-white-bis
    MainNavbar
      template(slot="brand")
        b-navbar-item(@click="back_handle")
          b-icon(icon="chevron-left")
        b-navbar-item.has-text-weight-bold.is-size-7-mobile(tag="div") {{page_title}}
    MainSection
      .container
        b-field.block(label="1. URLをコピー")
          .control
            b-button(icon-left="clipboard-plus-outline" @click="clipboard_copy_handle")
          b-input(type="text" :value="kento_api_url" expanded readonly)

        b-field.block(label="2. KENTO側で設定")
          .control
            b-button(tag="a" href="https://www.kento-shogi.com/setting" target="_blank" icon-right="open-in-new" @click="sound_play_click()") 移動

        .image.box.mt-5
          img(src="~/assets/kento_settings_api.png")

        .block
          | これでKENTO側でも棋譜一覧が出るようになります
</template>

<script>
export default {
  name: "SwarsUserKeyKentoApi",
  methods: {
    clipboard_copy_handle() {
      this.sound_play_click()
      this.clipboard_copy({text: this.kento_api_url})
    },
    back_handle() {
      this.sound_play_click()
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },
  },
  computed: {
    meta() {
      return {
        title: this.page_title,
        twitter_card_is_small: true,
        og_image_key: "swars-search",
        og_description: "",
      }
    },
    page_title() {
      return `${this.$route.params.key}さん専用の KENTO API 設定手順`
    },
    kento_api_url() {
      const params = new URLSearchParams()
      params.set("query", this.$route.params.key)
      params.set("format_type", "kento")
      return this.$config.MY_SITE_URL + `/w.json?${params}`
    },
  },
}
</script>

<style lang="sass">
.SwarsUserKeyKentoApi
  min-height: 100vh

  .MainSection.section
    &:first-of-type
      padding-top: 2.6rem

    .container
      max-width: 40rem

    .block:not(:first-child)
      margin-top: 2rem

  .image
    max-width: 400px
</style>
