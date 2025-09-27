<template lang="pug">
.AppEntryInfo.has-background-white-bis
  MainNavbar(:spaced="true")
    template(slot="brand")
      b-navbar-item(tag="nuxt-link" :to="{name: 'index'}" @click.native="title_click_handle")
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
              nuxt-link.card.is-block(:to="e.nuxt_link_to" @click.native="sfx_play_click()")
                .card-image
                  figure.image
                    //- b-image.is-marginless(:src="`/ogp/${e.og_image_key}.png`")
                    img(:src="`/ogp/${e.og_image_key}.png`" loading="lazy")
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
  .footer.when_mobile_footer_scroll_problem_workaround(v-if="config")
    .container
      .columns
        .column
          .title Apps
          ul
            template(v-for="e in config")
              template(v-if="e.display_p && !e.experiment_p")
                li
                  nuxt-link(:to="e.nuxt_link_to" @click.native="sfx_play_click()") {{e.title}}

        .column(v-if="false")
          .title Experiment
          ul
            template(v-for="e in config")
              template(v-if="e.display_p && e.experiment_p")
                li
                  nuxt-link(:to="e.nuxt_link_to" @click.native="sfx_play_click()") {{e.title}}

        .column
          .title About
          ul
            li
              nuxt-link(:to="{path: '/about/privacy-policy'}" @click.native="sfx_play_click()") プライバシーポリシー
            li
              nuxt-link(:to="{path: '/about/terms'}" @click.native="sfx_play_click()") 利用規約
            li
              nuxt-link(:to="{path: '/about/credit'}" @click.native="sfx_play_click()") クレジット
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
      .columns
        .column.has-text-right
          p.is-size-7 Last Update: {{$config.CSR_BUILD_VERSION}}
          p.is-size-7 Powered by <a href="https://www.ruby-lang.org/ja/" target="_blank">Ruby 3.4.2</a>, <a href="https://rubyonrails.org/" target="_blank">Rails 8.0.2.1</a>, <a href="https://nuxt.com/" target="_blank">Nuxt.js 2.18.1</a>
</template>

<script>
import { MyMobile } from "@/components/models/my_mobile.js"
import dayjs from "dayjs"
import _ from "lodash"

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
    title_click_handle() {
      this.sfx_play_click()
      this.toast_ok("SHOGI-EXTEND は将棋に関連したツールを提供するWEBサイトです")
    },
  },
  computed: {
    // 内容は nuxt.config.js と同じだけど設定は必要
    // 他のページから遷移してきたとき設定していないと title が undefined になってしまう
    meta() {
      return {
        title: this.$config.APP_NAME,
        page_title_only: true,
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
