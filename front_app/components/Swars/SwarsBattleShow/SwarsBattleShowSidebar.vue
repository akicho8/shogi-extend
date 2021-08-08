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

          b-menu-item.is_active_unset(label="アニメーション変換" tag="nuxt-link" :to="{name: 'heavy-export', query: {body: base.record.sfen_body, viewpoint_key: base.new_viewpoint}}" @click.native="sound_play('click')")

          b-menu-item.is_active_unset(:expanded="false" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in FormatTypeInfo.values")
              template(v-if="e.show")
                b-menu-item.is_active_unset(:label="e.name" @click="base.sidebar_close" :target="target_default" :href="show_url_for(e.key)")

          b-menu-item.is_active_unset(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | コピー
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in FormatTypeInfo.values")
              template(v-if="e.clipboard")
                b-menu-item.is_active_unset(:label="e.name" @click="swars_clipboard_copy_handle(e.key)")

          b-menu-item.is_active_unset(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              span.ml-1 ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            b-menu-item.is_active_unset(label="KIF"             @click="base.sidebar_close" :href="dl_url_for('kif')")
            b-menu-item.is_active_unset(label="KIF (Shift_JIS)" @click="base.sidebar_close" :href="dl_url_for('kif', {body_encode: 'Shift_JIS'})")
            b-menu-item.is_active_unset(label="KI2"             @click="base.sidebar_close" :href="dl_url_for('ki2')")
            b-menu-item.is_active_unset(label="CSA"             @click="base.sidebar_close" :href="dl_url_for('csa')")
            b-menu-item.is_active_unset(label="SFEN"            @click="base.sidebar_close" :href="dl_url_for('sfen')")
            b-menu-item.is_active_unset(label="BOD"             @click="base.sidebar_close" :href="dl_url_for('bod', {turn: base.new_turn})")
            b-menu-item.is_active_unset(label="PNG"             @click="base.sidebar_close" :href="dl_url_for('png', {turn: base.new_turn, viewpoint: base.new_viewpoint, width: ''})")

        b-menu-list(label="短かめの直リンコピー")
          b-menu-item.is_active_unset(label="この画面" @click="base.current_url_copy")
          b-menu-item.is_active_unset(label="ぴよ将棋" @click="base.short_url_copy('piyo_shogi')")
          b-menu-item.is_active_unset(label="KENTO"    @click="base.short_url_copy('kento')")

        b-menu-list(label="リンク")
          b-menu-item.is_active_unset(label="本家" @click="official_show_handle")

  //- PageCloseButton(@click="back_handle" position="is_absolute" size="is-medium")
  //- b-button.sidebar_toggle_button(icon-left="dots-vertical" @click="sidebar_toggle" type="is-text")
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"
import { FormatTypeInfo } from "@/components/models/format_type_info.js"

export default {
  name: "SwarsBattleShowSidebar",
  mixins: [support_child],
  methods: {
    show_url_for(format, params = {}) {
      const base_url = this.$config.MY_SITE_URL + this.base.record.show_path + "." + format
      const url = new URL(base_url)
      _.each(params, (val, key) => {
        url.searchParams.set(key, val)
      })
      return url.toString()
    },
    dl_url_for(format, params = {}) {
      return this.show_url_for(format, {attachment: "true", ...params})
    },
    async swars_clipboard_copy_handle(format, params = {}) {
      const retv = await this.kif_clipboard_copy({kc_path: this.base.record.show_path, kc_format: format})
      if (retv) {
        this.base.sidebar_close()
      }
    },
    official_show_handle() {
      this.sound_play("click")
      this.window_popup_if_desktop(this.official_show_url, {width: 400, height: 700})
    },
  },
  computed: {
    FormatTypeInfo() { return FormatTypeInfo },
    official_show_url() { return `https://shogiwars.heroz.jp/games/${this.base.record.key}` },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
