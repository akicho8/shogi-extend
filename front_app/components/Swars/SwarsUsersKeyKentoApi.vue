<template lang="pug">
.SwarsUsersKeyKentoApi
  b-navbar(type="is-primary" :mobile-burger="false" wrapper-class="container")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{title}}
  .section
    .container
      p 下のURLをKENTOの設定にコピペするとKENTOでも棋譜一覧が出るようになります
      b-field.mt-2
        b-input(type="text" :value="kento_api_url" expanded readonly)
        p.control
          b-button(icon-left="clipboard-plus-outline" @click="clipboard_copy({text: kento_api_url})")
      .buttons
        b-button.mt-3(tag="a" href="https://www.kento-shogi.com/setting" target="_blank" icon-right="open-in-new") KENTOの設定に移動
        span.has-text-grey.is-size-7
          | ※ 棋譜ソース → API追加
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
      return `${this.$route.params.key} さん専用の KENTO API`
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
  .section
    &:first-of-type
      padding-top: 1.8rem
</style>
