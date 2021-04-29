<template lang="pug">
b-sidebar.is-unselectable.SwarsBattleIndexSidebar(fullheight right overlay v-model="base.sidebar_p" v-if="base.config")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: base.config.current_swars_user_key}}" @click.native="sound_play('click')" label="プレイヤー情報" :disabled="menu_item_disabled")

        b-menu-list(label="表示形式")
          b-menu-item.is_active_unset(@click.stop="base.display_key_set('table')")
            template(slot="label")
              span(:class="{'has-text-weight-bold': base.display_key === 'table'}") テーブル
              b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="false && sound_play('click')")
                b-icon(icon="dots-vertical" slot="trigger")
                template(v-for="(e, key) in base.config.table_columns_hash")
                  b-dropdown-item.px-4(@click.native.stop="base.cb_toggle_handle(e)" :key="key")
                    span(:class="{'has-text-grey': !base.visible_hash[key], 'has-text-weight-bold': base.visible_hash[key]}") {{e.label}}
          b-menu-item.is_active_unset(label="開戦" @click.stop="base.display_key_set('critical')" :class="{'has-text-weight-bold': base.display_key === 'critical'}")
          b-menu-item.is_active_unset(label="中盤" @click.stop="base.display_key_set('outbreak')" :class="{'has-text-weight-bold': base.display_key === 'outbreak'}")
          b-menu-item.is_active_unset(label="終局" @click.stop="base.display_key_set('last')"     :class="{'has-text-weight-bold': base.display_key === 'last'}")

        b-menu-list(label="表示オプション")
          b-menu-item.is_active_unset(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示件数
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="per in base.config.per_page_list")
              b-menu-item.is_active_unset(:label="`${per}`" @click.stop="base.per_change_handle(per)" :class="{'has-text-weight-bold': per === base.config.per}")

          b-menu-item.is_active_unset(@click="sound_play('click')" :disabled="menu_item_disabled")
            template(slot="label" slot-scope="props")
              | フィルタ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            SwarsBattleIndexFilterMenuItem(:base="base" label="勝ち"            q="judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="負け"            q="judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="150手以上で勝ち" q="turn_max:>=150 judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="150手以上で負け" q="turn_max:>=150 judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="50手以下で勝ち"  q="turn_max:<=50 judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="50手以下で負け"  q="turn_max:<=50 judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="なし"            q="")

          b-menu-item.is_active_unset(@click="base.vs_input_handle" label="対戦相手で絞る" :disabled="menu_item_disabled")

        b-menu-list(label="一括取得")
          //- b-menu-item.is_active_unset(:disabled="menu_item_disabled" :expanded.sync="dl_menu_item_expanded_p" @click="sound_play('click')")
          //-   template(slot="label" slot-scope="props")
          //-     | 直近{{base.config.zip_dl_max_default}}件 ﾀﾞｳﾝﾛｰﾄﾞ
          //-     b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
          //-   template(v-for="e in ZipDlInfo.values")
          //-     b-menu-item.is_active_unset(@click="zip_dl_handle(e)" :label="e.name")

          b-menu-item.is_active_unset(
            label="ダウンロード"
            @click.native="base.config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-direct-download', query: base.current_route_query}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset(
            label="古い棋譜を補完"
            @click.native="base.config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-download-all', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="便利な使い方あれこれ")
          b-menu-item.is_active_unset(
            label="検索初期値の設定"
            @click.native="base.config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-default-key', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item.is_active_unset(label="ホーム画面に追加" @click="base.bookmark_desc" :disabled="menu_item_disabled")

          b-menu-item.is_active_unset(:disabled="menu_item_disabled" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 外部APP ｼｮｰﾄｶｯﾄ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in base.ExternalAppInfo.values")
              b-menu-item.is_active_unset(@click="base.external_app_handle(e)" :label="e.name")

          b-menu-item.is_active_unset(
            label="KENTO API"
            @click.native="base.config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: base.config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="test" v-if="development_p")
          b-menu-item.is_active_unset
            template(slot="label")
              | Devices
              b-dropdown.is-pulled-right(position="is-bottom-left")
                b-icon(icon="dots-vertical" slot="trigger")
                b-dropdown-item Action
                b-dropdown-item Action
                b-dropdown-item Action

        b-menu-list(label="DEBUG" v-if="development_p")
          b-menu-item.is_active_unset(label="棋譜の不整合"     @click="$router.push({query: {query: 'Yamada_Taro', error_capture_fake: true, force: true}})")
          b-menu-item.is_active_unset(label="棋譜の再取得"     @click="$router.push({query: {query: 'Yamada_Taro', destroy_all: true, force: true}})")
          b-menu-item.is_active_unset(label="棋譜の普通に取得" @click="$router.push({query: {query: 'Yamada_Taro'}})")
          b-menu-item.is_active_unset(label="☗を左に表示"     @click="$router.push({query: {query: 'Yamada_Taro', viewpoint: 'black'}})")
          b-menu-item.is_active_unset(label="☖を左に表示"     @click="$router.push({query: {query: 'Yamada_Taro', viewpoint: 'white'}})")
          b-menu-item.is_active_unset(label="全レコード表示"   @click="$router.push({query: {query: '', all: 'true', per: 50, debug: 'true'}})")
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
