<template lang="pug">
.index
  b-navbar(type="is-primary" :mobile-burger="false" wrapper-class="container" spaced)
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'index'}") SHOGI-EXTEND
  .section
    .container
      .columns.is-multiline
        template(v-for="e in config")
          template(v-if="e.display_p")
            .column.is-one-third-desktop.is-half-tablet(:key="e._key")
              nuxt-link.box(:to="e.nuxt_link_to")
                .content
                  .image
                    img(:src="`/ogp/${e.ogp_image_base}.png`")
                  .title.is-5.mt-5
                    h2.title.is-5.is-inline {{e.title}}
                    template(v-if="e.new_p")
                      span.has-text-danger.ml-2.is-size-6 NEW!
                  p(v-html="e.description")
                  ul.is-size-7.features
                    template(v-for="e in e.features")
                      li(v-html="e")

      pre {{config}}
</template>

<script>
export default {
  name: "index",
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
    return this.$axios.$get("/api/service_infos.json").then(config => {
      this.config = config
    })
  },
}
</script>

<style scoped lang="sass">
.features
  height: 3rem
</style>
