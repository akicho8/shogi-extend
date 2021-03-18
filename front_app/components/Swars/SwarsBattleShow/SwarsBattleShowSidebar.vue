<template lang="pug">
b-sidebar.SwarsBattleShowSidebar.is-unselectable(type="is-light" fullheight right v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(label="問題作成"               tag="nuxt-link" :to="{name: 'rack-articles-new', query: {body: base.record.sfen_body, turn: base.new_turn, viewpoint: base.new_viewpoint}}" @click.native="sound_play('click')")
          b-menu-item.is_active_unset(label="共有将棋盤に転送"       tag="nuxt-link" :to="{name: 'share-board', query: base.share_board_query}" @click.native="sound_play('click')")
          b-menu-item.is_active_unset(label="スタイルエディタに転送" tag="nuxt-link" :to="{name: 'style-editor', query: base.style_editor_query}" @click.native="sound_play('click')")

        b-menu-list(label="export")
          b-menu-item.is_active_unset(label="棋譜用紙 (PDF)"   tag="nuxt-link" :to="{name: 'swars-battles-key-formal-sheet', params: {key: base.record.key}}" @click.native="sound_play('click')")
          b-menu-item.is_active_unset(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              span.ml-1 表示
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            b-menu-item.is_active_unset(label="KIF"  @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.kif`")
            b-menu-item.is_active_unset(label="KI2"  @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.ki2`")
            b-menu-item.is_active_unset(label="CSA"  @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.csa`")
            b-menu-item.is_active_unset(label="SFEN" @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.sfen`")
            b-menu-item.is_active_unset(label="BOD"  @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.bod?turn=${base.new_turn}`")
            b-menu-item.is_active_unset(label="PNG"  @click.native="base.sidebar_close" :target="target_default" :href="`${$config.MY_SITE_URL}${base.record.show_path}.png?turn=${base.new_turn}&viewpoint=${base.new_viewpoint}&width=`")
          b-menu-item.is_active_unset(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              span.ml-1 ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            b-menu-item.is_active_unset(label="KIF"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.kif?attachment=true`")
            b-menu-item.is_active_unset(label="KIF (Shift_JIS)"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.kif?attachment=true&body_encode=Shift_JIS`")
            b-menu-item.is_active_unset(label="KI2"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.ki2?attachment=true`")
            b-menu-item.is_active_unset(label="CSA"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.csa?attachment=true`")
            b-menu-item.is_active_unset(label="SFEN" @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.sfen?attachment=true`")
            b-menu-item.is_active_unset(label="BOD"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.bod?attachment=true&turn=${base.new_turn}`")
            b-menu-item.is_active_unset(label="PNG"  @click.native="base.sidebar_close" :href="`${$config.MY_SITE_URL}${base.record.show_path}.png?attachment=true&turn=${base.new_turn}&viewpoint=${base.new_viewpoint}&width=`")

        b-menu-list(label="短かめの直リンコピー")
          b-menu-item.is_active_unset(label="この画面" @click="base.current_url_copy")
          b-menu-item.is_active_unset(label="ぴよ将棋" @click="base.short_url_copy('piyo_shogi')")
          b-menu-item.is_active_unset(label="KENTO"    @click="base.short_url_copy('kento')")

  //- PageCloseButton(@click="back_handle" position="is_absolute" size="is-medium")
  //- b-button.sidebar_toggle_button(icon-left="dots-vertical" @click="sidebar_toggle" type="is-text")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleShowSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsBattleShowSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
