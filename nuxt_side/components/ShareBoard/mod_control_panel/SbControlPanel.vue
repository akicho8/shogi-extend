<template lang="pug">
SbSidebar.SbControlPanel(v-model="SB.sidebar_p")
  .header
    NavbarItemSidebarClose(@click="SB.sidebar_toggle_handle")
    template(v-if="!SB.cable_p || !SB.i_am_member_p")
      NavbarItemLogin(component="a")
      NavbarItemProfileLink(component="a" :click_fn="SB.profile_click_handle")

  SbStartStep

  .box
    b-field(custom-class="is-small" label="局面操作")
      //- template(#message)
      //-   | 初期配置に戻せば同じ部屋で何度も対戦できます
      .button_elements
        //- 即実行
        b-button.reflector_turn_zero_handle(size="is-small" @click="SB.reflector_turn_zero_handle" :class="SB.bold_if(SB.current_turn >= 1)" :focused="SB.current_turn >= 1") 初期配置に戻す
        b-button.reflector_turn_previous_handle(size="is-small" @click="SB.reflector_turn_previous_handle") 1手戻す
        //- モーダル版
        template(v-if="SB.debug_mode_p")
          b-button.turn_change_to_zero_modal_open_handle(size="is-small" @click="SB.turn_change_to_zero_modal_open_handle" :class="SB.bold_if(SB.current_turn >= 1)") 初期配置に戻す
          b-button.turn_change_to_previous_modal_open_handle(size="is-small" @click="SB.turn_change_to_previous_modal_open_handle") 1手戻す
    p.help
      | 初期配置に戻せば同じ部屋で何度でも対局できます。戻さなければ途中の局面から対局できます。

  .box
    b-field(custom-class="is-small" label="対局サポート")
      .button_elements
        b-button.board_preset_modal_open_handle(size="is-small" @click="SB.board_preset_modal_open_handle") 手合割
        b-button.room_url_copy_handle(size="is-small" @click="SB.room_url_copy_handle") 部屋のURLのコピー
        template(v-if="SB.debug_mode_p")
          b-button.xmatch_modal_handle(size="is-small" @click="SB.xmatch_modal_handle") 自動マッチング
          b-button.room_recreate_modal_open_handle(size="is-small" @click="SB.room_recreate_modal_open_handle") 通信不調

  .box
    b-field(custom-class="is-small" label="検討")
      .button_elements
        b-button(size="is-small" tag="a" :href="SB.current_kifu_vo.piyo_url"  :target="target_default" @click="SB.other_app_click_handle('ぴよ将棋')" v-if="$PiyoShogiTypeCurrent.info.showable_p || SB.debug_mode_p") ぴよ将棋
        b-button(size="is-small" tag="a" :href="SB.current_kifu_vo.kento_url" target="_blank" @click="SB.other_app_click_handle('KENTO')") KENTO
        b-button.kifu_copy_handle_main(size="is-small" @click="SB.kifu_copy_handle('kif_utf8')") コピー

  .box
    b-field(custom-class="is-small" label="棋譜再生用URLのコピー")
      .button_elements
        b-button.current_short_url_copy_handle(size="is-small" @click.prevent="SB.current_short_url_copy_handle") 短縮版
        b-button.current_url_copy_handle(size="is-small" tag="a" :href="SB.current_url" @click.prevent="SB.current_url_copy_handle") 通常版
    p.help
      | 他者に棋譜を送る場合はURLの共有をおすすめします

  .box
    b-field(custom-class="is-small" label="インポート")
      .button_elements
        b-button.kifu_read_modal_open_handle(size="is-small" @click="SB.kifu_read_modal_open_handle('')") 棋譜の読み込み
        b-button.edit_mode_set_handle(size="is-small" @click="SB.edit_mode_set_handle") 局面編集

  .box.export_box
    b-field(custom-class="is-small" label="エクスポート")
      b-switch.export_group_visible_toggle_handle(size="is-small" v-model="SB.export_group_visible_p" @input="v => sfx_play_toggle(v)") ON

    template(v-if="SB.export_group_visible_p")
      hr

      b-field(custom-class="is-small" label="コピー")
        .button_elements
          template(v-for="e in SB.FormatTypeInfo.values")
            template(v-if="e.clipboard")
              b-button(size="is-small" @click="SB.kifu_copy_handle(e)" v-text="e.name_with_turn(SB.current_turn)" :class="['kifu_copy_handle', e.key]")

      b-field(custom-class="is-small" label="ダウンロード")
        .button_elements
          template(v-for="e in SB.FormatTypeInfo.values")
            template(v-if="e.show")
              b-button(size="is-small" tag="a" :href="SB.kifu_download_url(e)" @click.prevent="SB.kifu_download_handle(e)" v-text="e.name_with_turn(SB.current_turn)" :class="['kifu_download_url', e.key]")

      b-field(custom-class="is-small" label="表示")
        .button_elements
          template(v-for="e in SB.FormatTypeInfo.values")
            template(v-if="e.show")
              b-button(size="is-small" tag="a" :href="SB.kifu_show_url(e)" @click.prevent="SB.kifu_show_handle(e)" v-text="e.name_with_turn(SB.current_turn)" :class="['kifu_show_url', e.key]")

      hr

      b-field(custom-class="is-small" label="他")
        .button_elements
          b-button.image_download_modal_handle(size="is-small" @click="SB.image_download_modal_handle" v-text="`画像 #${SB.current_turn}`")
          b-button.video_new_handle(size="is-small" @click="SB.video_new_handle") 動画変換
          b-button.kifu_mail_handle(size="is-small" @click="SB.kifu_mail_handle") メール送信
          b-button.kifu_print_handle(size="is-small" @click="SB.kifu_print_handle") 棋譜用紙

  .box
    b-field(custom-class="is-small" label="その他")
      .button_elements
        b-button.general_setting_modal_open_handle(size="is-small" @click="SB.general_setting_modal_open_handle") 設定
        b-button.general_help_modal_open_handle(size="is-small" @click="SB.general_help_modal_open_handle") 使い方
        b-button.general_dashboard_modal_handle(size="is-small" @click="SB.general_dashboard_modal_handle" :disabled="!SB.cable_p") 対局履歴
        b-button.tweet_modal_handle(size="is-small" @click="SB.tweet_modal_handle") ツイート
        b-button.is-hidden-mobile.shortcut_modal_open_handle(size="is-small" @click="SB.shortcut_modal_open_handle") ショートカット

  .box(v-if="SB.debug_mode_p")
    b-field(custom-class="is-small" label="開発用")
      .button_elements
        b-button(size="is-small" tag="nuxt-link"  :to="{name: 'share-board-dashboard', query: {room_key: SB.room_key}}" @click.native="sfx_click()" :disabled="!SB.cable_p") 対局履歴(nuxt-link)
        b-button(size="is-small" tag="nuxt-link"  :to="{name: 'adapter', query: {body: SB.current_sfen, open: 'print'}}" @click.native="sfx_click()") 印刷
        b-button(size="is-small" tag="nuxt-link"  :to="{name: 'adapter', query: {body: SB.current_sfen}}" @click.native="sfx_click()") なんでも棋譜変換
        b-button(size="is-small" tag="a" :href="SB.dashboard_url" target="_blank" :disabled="!SB.cable_p") 対局履歴(hrefで別タブ)
        b-button.handle_name_modal_open_handle(size="is-small" @click="SB.handle_name_modal_open_handle") ハンドルネーム変更
        b-button.avatar_input_modal_open_handle(size="is-small" @click="SB.avatar_input_modal_open_handle") アバター設定
        b-button.title_edit_handle(size="is-small" @click="SB.title_edit_handle") タイトル変更
        b-button.appearance_modal_open_handle(size="is-small" @click="SB.appearance_modal_open_handle") スタイル設定
        b-button.tl_modal_open_handle(size="is-small" @click="SB.tl_modal_open_handle") デバッグ用ログ
        b-button.reset_handle(size="is-small" @click="SB.reset_handle" :disabled="!SB.cable_p") URLを開いたときの局面に戻す
        b-button(size="is-small" tag="nuxt-link" :to="{name: 'experiment-OrderUiTest'}" @click.native="sfx_click()") 手番検証
        b-button.audio_unlock_all_with_rooster(size="is-small" @click="SB.audio_unlock_all_with_rooster") 音復活

  .box(v-if="SB.debug_mode_p")
    pre
      | {{SB.users_match_record_master}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbControlPanel",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.SbControlPanel
  .NavbarItemSidebarClose
    padding-left:  2.5rem ! important
    padding-right: 2.5rem ! important

  .header
    display: flex
    align-items: center
    justify-content: space-between

  .button_elements
    display: flex
    flex-wrap: wrap
    gap: 0.5rem

  .user_account
    img
      max-height: none
      height: 32px
      width: 32px

.STAGE-development
  .SbControlPanel
    .button_elements
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
