<template lang="pug">
MainNavbar.WkbkArticleIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-books'}" @click.native="sfx_click()")
      b-icon(icon="chevron-left")
    //- NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'rack-articles'}") 問題リスト

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles-new'}" @click.native="sfx_click()")
      b-icon(icon="plus")

    //- https://buefy.org/documentation/navbar
    b-navbar-dropdown(arrowless v-if="development_p")
      //- https://pictogrammers.github.io/@mdi/font/5.4.55/
      b-icon(icon="table-row" slot="label")
      template(v-for="e in base.ArticleIndexColumnInfo.values")
        b-navbar-item.px-4(@click.native.prevent.stop="base.cb_toggle_handle(e)" :key="e.key" v-if="e.togglable")
          .has-text-weight-bold(v-if="base.visible_hash[e.key]")
            | {{e.name}}
          .has-text-grey(v-else)
            | {{e.name}}


    NavbarItemLogin
    NavbarItemProfileLink

    NavbarItemSidebarOpen.is-hidden-desktop(@click="base.sidebar_toggle")
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
</style>
