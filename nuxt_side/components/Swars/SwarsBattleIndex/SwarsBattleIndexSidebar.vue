<template lang="pug">
b-sidebar.is-unselectable.SwarsBattleIndexSidebar(fullheight right overlay v-model="base.sidebar_p" v-if="base.xi")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset.swars_users_key_handle(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: base.xi.current_swars_user_key}, query: {query: base.user_stat_query}}" @click.native="$sound.play_click()" label="プレイヤー情報" :disabled="menu_item_disabled")

          b-menu-item.swars_custom_search_handle(
            label="カスタム検索"
            @click.native="$sound.play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-search-custom', query: $gs.hash_compact({user_key: base.xi.current_swars_user_key})}"
            )

        b-menu-list(label="レイアウト")
          template(v-for="e in base.LayoutInfo.values")
            b-menu-item.is_active_unset(
              @click.stop="base.layout_key_set(e, $event)"
              :class="e.key"
              )
              template(slot="label")
                //- nuxt-link(:class="{'has-text-weight-bold': base.layout_info.key === e.key}" :to="{query: {layout_key: e.key}}" @click.native.stop.prevent="") {{e.name}}
                //- a(:class="{'has-text-weight-bold': base.layout_info.key === e.key}" href="/" @click.native.stop.prevent="") {{e.name}}
                span(:class="{'has-text-weight-bold': base.layout_info.key === e.key}") {{e.name}}
                template(v-if="e.key === 'is_layout_table'")
                  b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="false && $sound.play_click()")
                    b-icon(icon="dots-vertical" slot="trigger")
                    template(v-for="e in base.ColumnInfo.values")
                      b-dropdown-item.px-4(@click.native.stop="base.column_toggle_handle(e)" :key="e.key" v-if="e.available_p(base)")
                        span(:class="{'has-text-grey': !base.visible_hash[e.key], 'has-text-weight-bold': base.visible_hash[e.key]}")
                          | {{e.name}}

        b-menu-list(label="局面")
          template(v-for="e in base.SceneInfo.values")
            b-menu-item.is_active_unset(@click.stop="base.scene_key_set(e, $event)" :class="e.div_class")
              template(slot="label")
                span(:class="{'has-text-weight-bold': base.scene_info.key === e.key}") {{e.name}}

        b-menu-list(label="オプション")
          b-menu-item.is_active_unset.per_change_menu_item(@click="$sound.play_click()")
            template(slot="label" slot-scope="props")
              | {{base.PerInfo.field_label}}
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.PerInfo.values")
              b-menu-item.is_active_unset(
                v-if="e.available_p(base)"
                :label="e.name"
                @click.stop="base.per_set_handle(e)"
                :class="[{'has-text-weight-bold': base.per_info.per === e.per}, e.key]"
                )

        b-menu-list(label="まとめて取得")
          b-menu-item.is_active_unset.swars_direct_download_handle(
            label="ダウンロード"
            @click.native="base.xi.current_swars_user_key && $sound.play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-direct-download', query: base.current_route_query}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.swars_users_key_download_all_handle(
            label="古い棋譜を補完"
            @click.native="base.xi.current_swars_user_key && $sound.play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-download-all', params: {key: base.xi.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="一歩進んだ使い方")
          b-menu-item.is_active_unset.swars_default_user_key_set_handle(
            :class="{'has-text-weight-bold': base.mounted_then_swars_search_default_key_present_p}"
            @click.native="base.xi.current_swars_user_key && $sound.play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-default-key', params: {key: base.xi.current_swars_user_key}}"
            :disabled="menu_item_disabled")
            template(#label)
              | ウォーズIDを記憶する
              b-icon.is_hand(size="is-small" icon="arrow-left-bold" v-if="!menu_item_disabled && !base.mounted_then_swars_search_default_key_present_p")

          b-menu-item.is_active_unset.home_bookmark_handle(
            label="ホーム画面に追加"
            @click="base.home_bookmark_handle"
            :disabled="menu_item_disabled"
            )

          b-menu-item.is_active_unset.swars_users_key_kento_api_menu_item(
            label="KENTOから連携"
            @click.native="base.xi.current_swars_user_key && $sound.play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: base.xi.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.external_app_menu_item(:disabled="menu_item_disabled" @click="$sound.play_click()")
            template(slot="label" slot-scope="props")
              | 外部アプリですぐ開く
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.ExternalAppInfo.values")
              b-menu-item.is_active_unset(@click="base.external_app_handle(e)" :label="e.name" :class="e.dom_class")

        template(v-if="true")
          b-menu-list(label="その他")
            b-menu-item.is_active_unset(label="よくある質問 (FAQ)" @click="base.general_help_modal_handle")

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
      return !this.base.xi.current_swars_user_key
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
