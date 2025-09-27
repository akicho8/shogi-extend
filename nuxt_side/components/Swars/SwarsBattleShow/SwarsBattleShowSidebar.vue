<template lang="pug">
b-sidebar.SwarsBattleShowSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(label="共有将棋盤に転送"       tag="nuxt-link" :to="{name: 'share-board', query: base.share_board_query}" @click.native="sfx_play_click()")
          b-menu-item.is_active_unset(label="問題作成"               tag="nuxt-link" :to="{name: 'rack-articles-new', query: {body: base.record.sfen_body, turn: base.current_turn, viewpoint: base.viewpoint}}" @click.native="sfx_play_click()")
          b-menu-item.is_active_unset(label="ｽﾀｲﾙｴﾃﾞｨﾀに転送" tag="nuxt-link" :to="{name: 'style-editor', query: base.style_editor_query}" @click.native="sfx_play_click()")

        SbSidebarExport(:base="base")
          b-menu-item.is_active_unset(icon="printer" label="棋譜用紙 (PDF)" tag="nuxt-link" :to="{name: 'swars-battles-key-formal-sheet', params: {key: base.record.key}}" @click.native="sfx_play_click()")
          b-menu-item.is_active_unset(icon="movie"   label="動画変換"       tag="nuxt-link" :to="{name: 'video-new', query: {body: base.record.sfen_body, viewpoint: base.viewpoint}}" @click.native="sfx_play_click()")
          b-menu-item.is_active_unset(icon="image"   :label="`画像ダウンロード #${base.current_turn}`" @click.native="base.image_dl_modal_handle")

        b-menu-list(label="短かめの直リンコピー")
          b-menu-item.is_active_unset(label="この画面" @click="base.current_url_copy")
          b-menu-item.is_active_unset(label="ぴよ将棋" @click="base.short_url_copy('piyo_shogi')")
          b-menu-item.is_active_unset(label="KENTO"    @click="base.short_url_copy('kento')")

        b-menu-list(label="リンク")
          b-menu-item.is_active_unset(label="本家" @click="base.official_show_handle")
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "SwarsBattleShowSidebar",
  mixins: [support_child],
  methods: {
  },
  computed: {
  },
}
</script>

<style lang="sass">
.SwarsBattleShowSidebar
  .sidebar-content
    width: 20rem

  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem

  .menu-label:not(:first-child), .SbSidebarExport
    margin-top: 2em
</style>
