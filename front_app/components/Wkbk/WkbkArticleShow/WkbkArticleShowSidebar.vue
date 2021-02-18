<template lang="pug">
b-sidebar.WkbkArticleShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p" v-if="base.article")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action" v-if="development_p")
          //- b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles-new'}" label="問題作成" @click.native="sound_play('click')")
          b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles-article_key-edit', params: {article_key: base.article.key}}" label="編集" @click.native="sound_play('click')" v-if="base.editable_p")
          b-menu-item(label="ツイート" @click="base.tweet_handle")

        //- b-menu-list(label="表示オプション")
        //-
        //-   b-menu-item(@click="sound_play('click')")
        //-     template(slot="label" slot-scope="props")
        //-       | 図面表示
        //-       b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
        //-     b-field(custom-class="is-small")
        //-       b-radio-button(size="is-small" v-model="detail_p" :native-value="false") OFF
        //-       b-radio-button(size="is-small" v-model="detail_p" :native-value="true") ON
        //-
        //-   b-menu-item(v-if="development_p")
        //-     template(slot="label")
        //-       span 表示カラム
        //-       b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')")
        //-         b-icon(icon="dots-vertical" slot="trigger")
        //-         template(v-for="e in base.ArticleShowColumnInfo.values")
        //-           b-dropdown-item.px-4(@click.native.prevent.stop="base.cb_toggle_handle(e)" :key="e.key" v-if="e.togglable")
        //-             span(:class="{'has-text-grey': !base.visible_hash[e.key], 'has-text-weight-bold': base.visible_hash[e.key]}") {{e.name}}
        //-
        //-   b-menu-item.sidebar_columns_toggle(@click="sound_play('click')")
        //-     template(slot="label" slot-scope="props")
        //-       | 表示カラム
        //-       b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
        //-     template(v-for="e in base.ArticleShowColumnInfo.values")
        //-       b-menu-item(
        //-         v-if="e.togglable"
        //-         @click.stop="base.cb_toggle_handle(e)"
        //-         :class="{is_visible_off: !base.visible_hash[e.key], is_visible_on: base.visible_hash[e.key]}"
        //-         :key="e.key"
        //-         :label="e.name"
        //-         )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowSidebar",
  mixins: [support_child],

  computed: {
    // detail_p: {
    //   get()  { return this.base.detailed_keys.length >= 1 },
    //   set(v) { this.base.detail_set(v)                   },
    // },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleShowSidebar
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
