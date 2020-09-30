<template lang="pug">
.SwarsUsersKeyKentoApi.has-background-white-ter
  b-navbar(shadow :mobile-burger="false" wrapper-class="container" spaced)
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{title}}
  .section
    .container
      p 下のURLをKENTOの設定(棋譜ソース→API追加)にコピペするとKENTO側でも棋譜一覧を表示できるようになります
      b-field.mt-2
        b-input(type="text" :value="kento_api_url" expanded readonly)
        p.control
          b-button(icon-left="clipboard-plus-outline" @click="clipboard_copy({text: kento_api_url})")
      b-button.mt-3(tag="a" href="https://www.kento-shogi.com/setting" target="_blank" icon-right="open-in-new") KENTOの設定に移動
</template>

<script>
export default {
  name: "SwarsUsersKeyKentoApi",
  head() {
    return {
      title: this.title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.title,                                       },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary",                                        },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-search.png" },
        { hid: "og:description", property: "og:description", content: ""                                                },
      ],
    }
  },
  computed: {
    title() {
      return `${this.$route.params.key}さんのKENTO用API`
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
.SwarsUsersKeyKentoApi
  min-height: 100vh
  .section
    &:first-of-type
      padding-top: 1.8rem
</style>
