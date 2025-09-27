<template lang="pug">
MainNavbar.WkbkArticleShowNavbar(:spaced="false")
  template(v-if="base.article")
    template(slot="brand")
      b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles'}" @click.native="sfx_play_click()")
        b-icon(icon="chevron-left")
    template(slot="start")
      NavbarItemProfileLink(:user="base.article.user")
      b-navbar-item.has-text-weight-bold(tag="div") {{base.article.title || "(no title)"}}
    template(slot="end")
      b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles-article_key-edit', params: {article_key: base.article.key}}" @click.native="sfx_play_click()" v-if="base.owner_p")
        b-icon(icon="pencil")
      NavbarItemSidebarOpen(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleShowNavbar
  __css_keep__: 0
</style>
