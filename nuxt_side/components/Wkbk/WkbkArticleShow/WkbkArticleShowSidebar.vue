<template lang="pug">
b-sidebar.WkbkArticleShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p" v-if="base.article")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          //- b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'rack-articles-article_key-edit', params: {article_key: base.article.key}}" label="編集" @click.native="sfx_play_click()" :disabled="!base.owner_p")
          b-menu-item.is_active_unset(label="編集"     @click="base.article_edit_handle" :disabled="!base.owner_p")
          b-menu-item.is_active_unset(label="コピーして新規"  @click="base.article_new_handle" :disabled="!base.owner_p")
          b-menu-item.is_active_unset(label="ツイート" @click="base.tweet_handle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleShowSidebar
  __css_keep__: 0
</style>
