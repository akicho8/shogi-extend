<template lang="pug">
.service-infos.has-background-white-bis
  MainNavbar
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name: 'index'}" @click.native="title_click")
        h1.has-text-weight-bold SHOGI-EXTEND
    template(slot="end")
      b-navbar-item.has-text-weight-bold(:href="$config.MY_SITE_URL" v-if="development_p")
        | 3000
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'launcher'}" v-if="development_p")
        b-icon(icon="rocket")
      NavbarItemLogin
      NavbarItemProfileLink
  MainSection
    .container
      .columns.is-multiline
        template(v-for="e in config")
          template(v-if="e.display_p || development_p")
            .column.is-one-third-desktop.is-half-tablet
              nuxt-link.card.is-block(:to="e.nuxt_link_to" @click.native="sound_play('click')")
                .card-image
                  figure.image
                    //- b-image.is-marginless(:src="`/ogp/${e.og_image_key}.png`")
                    img(:src="`/ogp/${e.og_image_key}.png`")
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
  .footer(v-if="config")
    .container
      .columns
        .column.is-4.has-text-centered-tablet
          .title.is-6.mb-0.has-text-weight-bold App Map
          ul.mt-1
            template(v-for="e in config")
              template(v-if="e.display_p || development_p")
                li
                  nuxt-link(:to="e.nuxt_link_to" @click.native="sound_play('click')") {{e.title}}

        .column.is-4.has-text-centered-tablet
          .title.is-6.mb-0.has-text-weight-bold About
          ul.mt-1
            li
              nuxt-link(:to="{path: '/about/privacy-policy'}" @click.native="sound_play('click')") プライバシー
            li
              nuxt-link(:to="{path: '/about/terms'}" @click.native="sound_play('click')") 利用規約
            li
              nuxt-link(:to="{path: '/about/credit'}" @click.native="sound_play('click')") クレジット
            li
              ExternalLink(href="https://twitter.com/sgkinakomochi" beep) 問い合わせ


        .column.is-4.has-text-centered-tablet
          .title.is-6.mb-0.has-text-weight-bold GitHub
          ul.mt-1
            li
              ExternalLink(href="https://github.com/akicho8/shogi-extend" beep) shogi-extend
            li
              ExternalLink(href="https://akicho8.github.io/shogi-player/" beep) shogi-player
            li
              ExternalLink(href="https://github.com/akicho8/bioshogi" beep) bioshogi
            li
              ExternalLink(href="https://github.com/akicho8/SKK-JISYO.shogi" beep) 将棋用語辞書
            li
              ExternalLink(href="https://github.com/akicho8/shogi-mode" beep) shogi-mode.el
</template>

<script>
import { isMobile } from "@/components/models/is_mobile.js"

export default {
  name: "service-infos",
  data () {
    return {
      config: null,
    }
  },
  fetch() {
    return this.$axios.$get("/api/service_infos.json").then(config => {
      this.config = config
    })
  },
  methods: {
    title_click() {
      this.sound_play("click")
      this.toast_ok("SHOGI-EXTEND は将棋の便利ツールを提供するサイトです")
    },
  },
  computed: {
    // 内容は nuxt.config.js と同じだけど設定は必要
    // 他のページから遷移してきたとき設定していないと title が undefined になってしまう
    meta() {
      return {
        title: this.$config.APP_NAME,
        short_title: true,
      }
    },
  },
}
</script>

<style lang="sass">
.service-infos
  .box
    padding-bottom: 2rem

  .footer
    gcolor: $grey
    a
      color: inherit
</style>
