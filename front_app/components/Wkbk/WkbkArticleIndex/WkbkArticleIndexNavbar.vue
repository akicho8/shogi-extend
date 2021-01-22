<template lang="pug">
MainNavbar.WkbkArticleIndexNavbar(:spaced="false")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'wkbk-articles'}") 問題一覧
    template(v-if="base.page_info.tag")
      b-tag(attached closable @close="base.tag_search_handle(null)" rounded type="is-dark")
        | {{base.page_info.tag}}

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    //- https://buefy.org/documentation/navbar
    b-navbar-dropdown(arrowless v-if="development_p")
      //- https://pictogrammers.github.io/@mdi/font/5.4.55/
      b-icon(icon="table-row" slot="label")
      template(v-for="e in base.ArticleIndexColumnInfo.values")
        b-navbar-item.px-4(@click.native.stop="base.cb_toggle_handle(e)" :key="e.key")
          .has-text-weight-bold(v-if="base.visible_hash[e.key]")
            | {{e.name}}
          .has-text-grey(v-else)
            | {{e.name}}

    b-navbar-item.has-text-weight-bold.px-5(tag="nuxt-link" :to="{name: 'wkbk-articles-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    b-navbar-item(@click="base.sidebar_toggle")
      b-icon(icon="menu")
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
