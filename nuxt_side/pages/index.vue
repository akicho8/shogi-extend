<template lang="pug">
.AppEntryInfo.has-background-white-bis
  MainNavbar(:spaced="true")
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
          template(v-if="(e.display_p && !e.experiment_p) || development_p")
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
                      template(v-if="e.attention_label")
                        span.has-text-danger.ml-2.is-size-6 {{e.attention_label}}
                    p(v-html="e.description")
                    ul.is-size-7.features
                      template(v-for="e in e.features")
                        li(v-html="e")
  .footer(v-if="config")
    .container
      .columns
        .column
          .title Apps
          ul
            template(v-for="e in config")
              template(v-if="e.display_p && !e.experiment_p")
                li
                  nuxt-link(:to="e.nuxt_link_to" @click.native="sound_play('click')") {{e.title}}

        .column
          .title Experiment
          ul
            template(v-for="e in config")
              template(v-if="e.display_p && e.experiment_p")
                li
                  nuxt-link(:to="e.nuxt_link_to" @click.native="sound_play('click')") {{e.title}}

        .column
          .title About
          ul
            li
              nuxt-link(:to="{path: '/about/privacy-policy'}" @click.native="sound_play('click')") プライバシー
            li
              nuxt-link(:to="{path: '/about/terms'}" @click.native="sound_play('click')") 利用規約
            li
              nuxt-link(:to="{path: '/about/credit'}" @click.native="sound_play('click')") クレジット
            li
              ExternalLink(href="https://twitter.com/sgkinakomochi" beep) 問い合わせ

        .column
          .title GitHub
          ul
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
  name: "AppEntryInfo",
  data () {
    return {
      config: null,
    }
  },
  fetch() {
    return this.$axios.$get("/api/app_entry_infos.json").then(config => {
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
.AppEntryInfo
  .MainSection.section, .footer
    +mobile
      padding: 0.75rem
      .columns
        margin: 0
      .column
        padding: 0
        &:not(:first-child)
          margin-top: 0.75rem
    +tablet
      padding: 1.5rem

  .footer
    color: $text
    padding-bottom: 8rem
    .title
      font-size: $size-5
      font-weight: bold
      margin-bottom: 0
      +mobile
        margin-top: 1rem
        line-height: 2.5rem
        border-bottom: 1px solid $grey-lighter
    ul
      margin-top: 0.75rem
    li
      margin: 0.5rem 0
      a
        color: inherit

  .box
    padding-bottom: 2rem
</style>
