<template lang="pug">
.WkbkArticleIndexSidebarBody
  b-menu
    //- b-menu-list(label="Action" v-if="development_p")
    //-   b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'rack-articles-new'}" label="問題作成" @click.native="sfx_click()")

    b-menu-list(label="コンテンツ")
      b-menu-item(tag="nuxt-link" :to="{name: 'rack-articles'}" label="問題リスト"   @click.native="sfx_click()")
      b-menu-item(tag="nuxt-link" :to="{name: 'rack-books'}"    label="問題集リスト" @click.native="sfx_click()")

    b-menu-list(label="表示オプション")
      b-menu-item.is_active_unset.sidebar_columns_toggle(:disabled="base.display_option_disabled" @click="sfx_click()")
        template(slot="label" slot-scope="props")
          | 表示カラム
          b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
        template(v-for="e in base.ArticleIndexColumnInfo.values")
          b-menu-item.is_active_unset(
            v-if="e.togglable"
            @click.stop="base.cb_toggle_handle(e)"
            :class="{is_visible_off: !base.visible_hash[e.key], is_visible_on: base.visible_hash[e.key]}"
            :key="e.key"
            :label="e.name"
            )

      b-menu-item.is_active_unset(@click="sfx_click()" :disabled="base.display_option_disabled")
        template(slot="label" slot-scope="props")
          | 図面表示
          b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
        b-field(custom-class="is-small")
          b-radio-button(size="is-small" v-model="base.detail_p" :native-value="false") OFF
          b-radio-button(size="is-small" v-model="base.detail_p" :native-value="true") ON

      b-menu-item.is_active_unset(:disabled="base.display_option_disabled" v-if="development_p")
        template(slot="label")
          span 表示カラム
          b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="sfx_click()")
            b-icon(icon="dots-vertical" slot="trigger")
            template(v-for="e in base.ArticleIndexColumnInfo.values")
              b-dropdown-item.px-4(@click.native.prevent.stop="base.cb_toggle_handle(e)" :key="e.key" v-if="e.togglable")
                span(:class="{'has-text-grey': !base.visible_hash[e.key], 'has-text-weight-bold': base.visible_hash[e.key]}") {{e.name}}

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleIndexSidebarBody",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleIndexSidebarBody
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .menu
      border: 1px dashed change_color($primary, $alpha: 0.5)

.is-fixed
  .WkbkArticleIndexSidebarBody
    padding: 1.25rem 1rem

.is-static
  .WkbkArticleIndexSidebarBody
    padding: 1rem 1rem

// 共通
.WkbkArticleIndexSidebarBody
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
