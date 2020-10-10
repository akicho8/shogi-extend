<template lang="pug">
.service-infos.has-background-white-bis
  b-navbar(type="is-primary" :mobile-burger="false" wrapper-class="container" spaced)
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name: 'index'}")
        h1.has-text-weight-bold SHOGI-EXTEND
    template(slot="end")
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'launcher'}" v-if="development_p") Launcher
      NavbarItemCurrentUser
  .section
    .container
      .columns.is-multiline
        template(v-for="e in config")
          template(v-if="e.display_p || development_p")
            .column.is-one-third-desktop.is-half-tablet
              nuxt-link.card.is-block(:to="e.nuxt_link_to" @click.native="sound_play('click')")
                .card-image
                  figure.image
                    //- b-image.is-marginless(:src="`/ogp/${e.ogp_image_base}.png`")
                    img(:src="`/ogp/${e.ogp_image_base}.png`")
                .card-content
                  .content
                    .title.is-5.mt-2
                      h2.title.is-5.is-inline {{e.title}}
                      template(v-if="e.new_p")
                        span.has-text-danger.ml-2.is-size-6 NEW!
                    p(v-html="e.description")
                    ul.is-size-7.features
                      template(v-for="e in e.features")
                        li(v-html="e")
  .footer
    .container
      .columns
        .column.is-half.has-text-centered
          .title.is-6.mb-0.has-text-weight-bold About
          ul.mt-1
            li
              nuxt-link(:to="{path: '/about/privacy-policy'}") プライバシー
            li
              nuxt-link(:to="{path: '/about/terms'}") 利用規約
            li
              nuxt-link(:to="{path: '/about/credit'}") クレジット
            li
              a(href="https://twitter.com/sgkinakomochi" :target="target_default") 問い合わせ

        .column.is-half.has-text-centered
          .title.is-6.mb-0.has-text-weight-bold GitHub
          ul.mt-1
            li
              a(href="https://github.com/akicho8/shogi_web" :target="target_default") shogi_web
            li
              a(href="https://akicho8.github.io/shogi-player/" :target="target_default") shogi-player
            li
              a(href="https://github.com/akicho8/bioshogi" :target="target_default") bioshogi
            li
              a(href="https://github.com/akicho8/SKK-JISYO.shogi" :target="target_default") 将棋用語辞書
            li
              a(href="https://github.com/akicho8/shogi-mode" :target="target_default") shogi-mode.el
</template>

<script>
export default {
  name: "service-infos",
  data () {
    return {
      config: null,
    }
  },
  head() {
    return {
      title: "SHOGI-EXTEND",
      titleTemplate: null,
      meta: [
        { hid: "og:title",       property: "og:title",       content: "SHOGI-EXTEND",                                   },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image",                            },
        { hid: "og:image",       property: "og:image",       content: "/ogp/application.png",                           },
        { hid: "og:description", property: "og:description", content: "将棋に関連する便利サービスを提供するサイトです", },
      ],
    }
  },
  fetch() {
    this.call_log("index")
    return this.$axios.$get("/api/service_infos.json").then(config => {
      this.config = config
    })
  },
}
</script>

<style lang="sass">
.service-infos
  .box
    padding-bottom: 2rem

  .features
    height: 3rem

  .footer
    color: $grey
    a
      color: inherit
</style>
