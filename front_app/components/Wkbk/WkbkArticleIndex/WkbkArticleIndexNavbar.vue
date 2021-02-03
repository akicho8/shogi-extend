<template lang="pug">
MainNavbar.WkbkArticleIndexNavbar(:spaced="false")
  template(slot="brand")
    b-navbar-item(tag="nuxt-link" :to="{name: 'library-books'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    //- NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'library-articles'}") 問題リスト

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    //- https://buefy.org/documentation/navbar
    b-navbar-dropdown(arrowless v-if="development_p")
      //- https://pictogrammers.github.io/@mdi/font/5.4.55/
      b-icon(icon="table-row" slot="label")
      template(v-for="e in base.ArticleIndexColumnInfo.values")
        b-navbar-item.px-4(@click.native.stop="base.cb_toggle_handle(e)" :key="e.key" v-if="e.togglable")
          .has-text-weight-bold(v-if="base.visible_hash[e.key]")
            | {{e.name}}
          .has-text-grey(v-else)
            | {{e.name}}

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'library-articles-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    WkbkSidebarToggle(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleIndexNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexNavbar
</style>
