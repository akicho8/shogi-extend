<template lang="pug">
b-sidebar.is-unselectable.SwarsBattleIndexSidebar(fullheight right overlay v-model="base.sidebar_p" v-if="base.config")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset.swars_users_key_handle(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: base.config.current_swars_user_key}}" @click.native="sound_play_click()" label="プレイヤー情報" :disabled="menu_item_disabled")

        b-menu-list(label="レイアウト")
          template(v-for="e in base.LayoutInfo.values")
            b-menu-item.is_active_unset(
              @click.stop="base.layout_key_set(e)"
              :class="e.key"
              )
              template(slot="label")
                span(:class="{'has-text-weight-bold': base.layout_info.key === e.key}") {{e.name}}
                template(v-if="e.key === 'is_layout_table'")
                  b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="false && sound_play_click()")
                    b-icon(icon="dots-vertical" slot="trigger")
                    template(v-for="e in base.ColumnInfo.values")
                      b-dropdown-item.px-4(@click.native.stop="base.column_toggle_handle(e)" :key="e.key" v-if="e.available_p(base)")
                        span(:class="{'has-text-grey': !base.visible_hash[e.key], 'has-text-weight-bold': base.visible_hash[e.key]}")
                          | {{e.name}}

        b-menu-list(label="局面")
          template(v-for="e in base.SceneInfo.values")
            b-menu-item.is_active_unset(@click.stop="base.scene_key_set(e)" :class="e.div_class")
              template(slot="label")
                span(:class="{'has-text-weight-bold': base.scene_info.key === e.key}") {{e.name}}

        b-menu-list(label="オプション")
          b-menu-item.is_active_unset.per_change_menu_item(@click="sound_play_click()")
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

          b-menu-item.is_active_unset.filter_set_menu_item(@click="sound_play_click()" :disabled="menu_item_disabled")
            template(slot="label" slot-scope="props")
              | {{base.QueryPresetInfo.field_label}}
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.QueryPresetInfo.values")
              SwarsBattleIndexMenuItemSelect(
                v-if="e.available_p(base)"
                :base="base"
                :class="e.key"
                :label="e.name"
                :query_preset_info="e"
                )

          b-menu-item.is_active_unset.vs_user_modal_handle(@click="base.vs_user_modal_handle" label="相手で絞る" :disabled="menu_item_disabled")

        b-menu-list(label="まとめて取得")
          b-menu-item.is_active_unset.swars_direct_download_handle(
            label="ダウンロード"
            @click.native="base.config.current_swars_user_key && sound_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-direct-download', query: base.current_route_query}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.swars_users_key_download_all_handle(
            label="古い棋譜を補完"
            @click.native="base.config.current_swars_user_key && sound_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-download-all', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="一歩進んだ使い方")
          b-menu-item.is_active_unset(
            label="ウォーズIDを覚える"
            :class="{'has-text-weight-bold': base.swars_search_default_key_blank_if_mounted}"
            @click.native="base.config.current_swars_user_key && sound_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-default-key', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.home_bookmark_handle(
            label="ホーム画面に追加"
            @click="base.home_bookmark_handle"
            :disabled="menu_item_disabled"
            )

          b-menu-item.is_active_unset.swars_users_key_kento_api_menu_item(
            label="KENTOから連携"
            @click.native="base.config.current_swars_user_key && sound_play_click()"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset.external_app_menu_item(:disabled="menu_item_disabled" @click="sound_play_click()")
            template(slot="label" slot-scope="props")
              | 外部アプリですぐ開く
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.ExternalAppInfo.values")
              b-menu-item.is_active_unset(@click="base.external_app_handle(e)" :label="e.name" :class="e.dom_class")

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
      return !this.base.config.current_swars_user_key
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
