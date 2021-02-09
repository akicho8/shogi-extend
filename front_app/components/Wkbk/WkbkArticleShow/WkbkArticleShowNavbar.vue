<template lang="pug">
MainNavbar.WkbkArticleShowNavbar(:spaced="false")
  template(v-if="base.article")
    template(slot="brand")
      b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles'}" @click.native="sound_play('click')")
        b-icon(icon="chevron-left")
    template(slot="start")
      NavbarItemProfileLink(:user="base.article.user")
      b-navbar-item.has-text-weight-bold(tag="div") {{base.article.title}}
    template(slot="end")
      //- b-navbar-item(tag="nuxt-link" :to="{name: 'rack-articles-article_key-edit', params: {article_key: base.article.key}}" v-if="base.editable_p")
      //-   | 編集
      WkbkSidebarToggle(@click="base.sidebar_toggle")
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
</style>
