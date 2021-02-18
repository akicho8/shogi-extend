<template lang="pug">
b-sidebar.WkbkArticleShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p" v-if="base.article")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles-article_key-edit', params: {article_key: base.article.key}}" label="編集" @click.native="sound_play('click')" v-if="base.editable_p")
          b-menu-item(label="ツイート" @click="base.tweet_handle")
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
</style>
