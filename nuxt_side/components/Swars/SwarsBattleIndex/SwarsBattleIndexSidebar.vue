<template lang="pug">
b-sidebar.is-unselectable.SwarsBattleIndexSidebar(fullheight right overlay v-model="APP.sidebar_p" v-if="APP.xi")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="APP.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset.swars_users_key_handle(
            label="プレイヤー情報"
            tag="nuxt-link"
            :to="{name: 'swars-users-key', params: {key: APP.xi.current_swars_user_key}, query: {query: APP.query_for_link}}"
            @click.native="sfx_play_click()"
            :disabled="menu_item_disabled"
          )

          b-menu-item.is_active_unset.swars_search_custom_handle(
            label="カスタム検索"
            @click.native="sfx_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-search-custom', query: $gs.hash_compact({user_key: APP.xi.current_swars_user_key})}"
            )

          b-menu-item.is_active_unset(label="詳細を一気に開く" @click="APP.show_url_all_open_handle")

        b-menu-list(label="調べる")
          b-menu-item.is_active_unset.swars_tactic_stat_handle(
            label="戦法勝率ランキング"
            @click.native="sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/tactic-stat', query: {back_to: $route.fullPath}}"
            )

          b-menu-item.is_active_unset.swars_tactic_list_handle(
            label="戦法一覧"
            @click.native="sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/tactic-list', query: {back_to: $route.fullPath}}"
            )

          b-menu-item.is_active_unset.swars_cross_search_handle(
            label="横断棋譜検索"
            @click.native="sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/cross-search', query: {back_to: $route.fullPath}}"
            )

        b-menu-list(label="レイアウト")
          template(v-for="e in APP.LayoutInfo.values")
            b-menu-item.is_active_unset(
              @click.stop="APP.layout_key_set(e, $event)"
              :class="e.key"
              )
              template(slot="label")
                //- nuxt-link(:class="{'has-text-weight-bold': APP.layout_info.key === e.key}" :to="{query: {layout_key: e.key}}" @click.native.stop.prevent="") {{e.name}}
                //- a(:class="{'has-text-weight-bold': APP.layout_info.key === e.key}" href="/" @click.native.stop.prevent="") {{e.name}}
                span(:class="{'has-text-weight-bold': APP.layout_info.key === e.key}") {{e.name}}
                template(v-if="e.key === 'is_layout_table'")
                  b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="false && sfx_play_click()")
                    b-icon(icon="dots-vertical" slot="trigger")
                    template(v-for="e in APP.ColumnInfo.values")
                      b-dropdown-item.px-4(@click.native.stop="APP.column_toggle_handle(e)" :key="e.key" v-if="e.available_p(APP)")
                        span(:class="{'has-text-grey': !APP.visible_hash[e.key], 'has-text-weight-bold': APP.visible_hash[e.key]}")
                          | {{e.name}}

        b-menu-list(label="局面")
          template(v-for="e in APP.SceneInfo.values")
            b-menu-item.is_active_unset(@click.stop="APP.scene_key_set(e, $event)" :class="e.div_class")
              template(slot="label")
                span(:class="{'has-text-weight-bold': APP.scene_info.key === e.key}") {{e.name}}

        b-menu-list(label="オプション")
          b-menu-item.is_active_unset.per_change_menu_item(@click="sfx_play_click()")
            template(slot="label" slot-scope="props")
              | {{APP.PerInfo.field_label}}
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in APP.PerInfo.values")
              b-menu-item.is_active_unset(
                v-if="e.available_p(APP)"
                :label="e.name"
                @click.stop="APP.per_set_handle(e)"
                :class="[{'has-text-weight-bold': APP.per_info.per === e.per}, e.key]"
                )

        b-menu-list(label="まとめて取得")
          b-menu-item.is_active_unset.swars_direct_download_handle(
            label="棋譜ダウンロード"
            @click.native="APP.xi.current_swars_user_key && sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/battle-download', query: {query: APP.xi.query, back_to: $route.fullPath}}"
            )

          b-menu-item.is_active_unset.swars_users_key_download_all_handle(
            label="古い棋譜の補完"
            @click.native="APP.xi.current_swars_user_key && sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/crawler-batch', query: {swars_user_key: APP.xi.current_swars_user_key, back_to: $route.fullPath}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.swars_users_key_battle_history_handle(
            label="対局履歴のエクスポート"
            @click.native="APP.xi.current_swars_user_key && sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/battle-history', query: {query: APP.xi.query, back_to: $route.fullPath}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="一歩進んだ使い方")
          b-menu-item.is_active_unset.swars_default_user_key_set_handle(
            :class="{'has-text-weight-bold': APP.mounted_then_swars_search_default_key_present_p}"
            @click.native="APP.xi.current_swars_user_key && sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/swars/search-default', query: {swars_search_default_key: APP.xi.current_swars_user_key, back_to: $route.fullPath}}"
            :disabled="menu_item_disabled")
            template(#label)
              | ウォーズIDを記憶する
              b-icon.is_hand(size="is-small" icon="arrow-left-bold" v-if="!menu_item_disabled && !APP.mounted_then_swars_search_default_key_present_p")

          b-menu-item.is_active_unset(
            @click.native="sfx_play_click()"
            tag="nuxt-link"
            :to="{path: '/lab/general/piyo-shogi-config', query: {back_to: $route.fullPath}}"
            )
            template(#label)
              | ぴよ将棋の設定

          b-menu-item.is_active_unset.home_bookmark_handle(
            label="ホーム画面に追加"
            @click="APP.home_bookmark_handle"
            :disabled="menu_item_disabled"
            )

          b-menu-item.is_active_unset.swars_users_key_kento_api_menu_item(
            label="KENTOから連携"
            @click.native="APP.xi.current_swars_user_key && sfx_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: APP.xi.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.external_app_menu_item(:disabled="menu_item_disabled" @click="sfx_play_click()")
            template(slot="label" slot-scope="props")
              | 外部アプリですぐ開く
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in APP.ExternalAppInfo.values")
              b-menu-item.is_active_unset(@click="APP.external_app_handle(e)" :label="e.name" :class="e.dom_class")

        template(v-if="true")
          b-menu-list(label="その他")
            b-menu-item.is_active_unset(label="よくある質問 (FAQ)" tag="nuxt-link" to="/swars/search/help")
            b-menu-item.is_active_unset(label="ショートカット" @click="APP.shortcut_modal_open_handle")

        b-menu-list(label="test" v-if="development_p")
          b-menu-item.is_active_unset
            template(slot="label")
              | Devices
              b-dropdown.is-pulled-right(position="is-bottom-left")
                b-icon(icon="dots-vertical" slot="trigger")
                b-dropdown-item Action
                b-dropdown-item Action
                b-dropdown-item Action
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexSidebar",
  mixins: [support_child],
  computed: {
    menu_item_disabled() {
      return !this.APP.xi.current_swars_user_key
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
