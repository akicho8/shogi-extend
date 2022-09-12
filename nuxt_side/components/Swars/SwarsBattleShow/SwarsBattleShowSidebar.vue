<template lang="pug">
b-sidebar.SwarsBattleShowSidebar.is-unselectable(type="is-light" fullheight right v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(label="共有将棋盤に転送"       tag="nuxt-link" :to="{name: 'share-board', query: base.share_board_query}" @click.native="sound_play_click()")
          b-menu-item.is_active_unset(label="問題作成"               tag="nuxt-link" :to="{name: 'rack-articles-new', query: {body: base.record.sfen_body, turn: base.current_turn, viewpoint: base.sp_viewpoint}}" @click.native="sound_play_click()")
          b-menu-item.is_active_unset(label="スタイルエディタに転送" tag="nuxt-link" :to="{name: 'style-editor', query: base.style_editor_query}" @click.native="sound_play_click()")
          b-menu-item.is_active_unset(:label="`局面ペディア #${base.current_turn}`" :href="base.kpedia_url" :target="target_default" @click="base.other_app_click_handle('局面ペディア')")

        ShareBoardSidebarExport(:base="base")
          b-menu-item.is_active_unset(icon="printer" label="棋譜用紙 (PDF)" tag="nuxt-link" :to="{name: 'swars-battles-key-formal-sheet', params: {key: base.record.key}}" @click.native="sound_play_click()")
          b-menu-item.is_active_unset(icon="movie"   label="動画変換"       tag="nuxt-link" :to="{name: 'video-new', query: {body: base.record.sfen_body, viewpoint_key: base.sp_viewpoint}}" @click.native="sound_play_click()")
          b-menu-item.is_active_unset(icon="image"   :label="`画像ダウンロード #${base.current_turn}`" @click.native="base.image_dl_modal_handle")

        b-menu-list(label="短かめの直リンコピー")
          b-menu-item.is_active_unset(label="この画面" @click="base.current_url_copy")
          b-menu-item.is_active_unset(label="ぴよ将棋" @click="base.short_url_copy('piyo_shogi')")
          b-menu-item.is_active_unset(label="KENTO"    @click="base.short_url_copy('kento')")

        b-menu-list(label="リンク")
          b-menu-item.is_active_unset(label="本家" @click="base.official_show_handle")

  //- PageCloseButton(@click="back_handle" position="is_absolute" size="is-medium")
  //- b-button.sidebar_toggle_button(icon-left="dots-vertical" @click="sidebar_toggle" type="is-text")
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
    official_show_url() { return `https://shogiwars.heroz.jp/games/${this.base.record.key}` },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowSidebar
  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem

  .menu-label:not(:first-child), .ShareBoardSidebarExport
    margin-top: 2em
</style>
