<template lang="pug">
.SwarsUsersKeyKentoApi
  b-navbar(type="is-primary" :mobile-burger="false" wrapper-class="container")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{title}}
  .section
    .container
      p 1. 下のURLをコピー
      b-field.mt-3
        p.control
          b-button(icon-left="clipboard-plus-outline" @click="clipboard_copy({text: kento_api_url})")
        b-input(type="text" :value="kento_api_url" expanded readonly)

      p.mt-6 2. 下のボタンで移動して<b>API追加</b>にペースト
      b-button.mt-3(tag="a" href="https://www.kento-shogi.com/setting" target="_blank" icon-right="open-in-new") KENTOの設定に移動

      p.mt-6.mb-0
        | これでKENTO側でも棋譜一覧が出るようになります

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
      return `${this.$route.params.key} さん専用の KENTO API 設定手順`
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
      padding-top: 2.6rem
</style>
