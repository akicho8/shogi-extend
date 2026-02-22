<template lang="pug">
//- https://buefy.org/documentation/sidebar
b-sidebar.is-unselectable.SbControlPanel(fullheight right overlay v-model="SB.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      NavbarItemSidebarClose(@click="SB.sidebar_toggle_handle")
      template(v-if="$GX.blank_p(SB.ac_room) || !SB.i_am_member_p")
        NavbarItemLogin(component="a")
        NavbarItemProfileLink(component="a" :click_fn="SB.profile_click_handle")
    .mt-4
      SbStartStep

      b-menu
        b-menu-list(label="局面操作")
          //- 即実行
          b-menu-item.is_active_unset.force_sync_turn_zero_handle(icon="page-first" label="初期配置に戻す"   @click="SB.force_sync_turn_zero_handle" :class="SB.bold_if(SB.current_turn >= 1)" :disabled="SB.current_turn === 0")
          b-menu-item.is_active_unset.force_sync_turn_previous_handle(icon="undo"   label="1手戻す (待った)" @click="SB.force_sync_turn_previous_handle" :disabled="SB.current_turn === 0")
          //- モーダル版
          b-menu-item.is_active_unset.turn_change_to_zero_modal_open_handle(icon="page-first"  label="初期配置に戻す"   @click="SB.turn_change_to_zero_modal_open_handle" :class="SB.bold_if(SB.current_turn >= 1)" v-if="SB.debug_mode_p")
          b-menu-item.is_active_unset.turn_change_to_previous_modal_open_handle(icon="undo"    label="1手戻す (待った)" @click="SB.turn_change_to_previous_modal_open_handle" v-if="SB.debug_mode_p")

        b-menu-list(label="対局サポート")
          b-menu-item.is_active_unset(icon="scale-balance"          label="手合割"               @click="SB.board_preset_modal_open_handle")
          b-menu-item.is_active_unset(icon="link"                   label="部屋のリンクのコピー" @click="SB.room_url_copy_handle")
          b-menu-item.is_active_unset(icon="heart"                  label="自動マッチング"       @click="SB.xmatch_modal_handle" v-if="$config.STAGE !== 'production'")
          b-menu-item.is_active_unset(icon="restart"                label="再起動"               @click="SB.room_recreate_modal_open_handle" v-if="SB.debug_mode_p")
          b-menu-item.is_active_unset(icon="home" label="対局履歴" @click="SB.general_dashboard_modal_handle" :disabled="$GX.blank_p(SB.ac_room)")
          b-menu-item.is_active_unset(icon="trophy" tag="nuxt-link" label="対局履歴(nuxt-link)" :to="{name: 'share-board-dashboard', query: {room_key: SB.room_key}}" @click.native="sfx_click()" :disabled="$GX.blank_p(SB.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(icon="trophy" label="対局履歴(hrefで別タブ)" :href="SB.dashboard_url" target="_blank" :disabled="$GX.blank_p(SB.ac_room)" v-if="development_p")

        b-menu-list(label="検討")
          b-menu-item.is_active_unset(icon="clipboard-plus-outline" label="棋譜コピー (KIF)" @click="SB.kifu_copy_handle('kif_utf8')")
          b-menu-item.is_active_unset(icon="duck"                   label="ぴよ将棋"         :href="SB.current_kifu_vo.piyo_url"  :target="target_default" @click="SB.other_app_click_handle('ぴよ将棋')" v-if="$PiyoShogiTypeCurrent.info.showable_p || SB.debug_mode_p")
          b-menu-item.is_active_unset(icon="alpha-k-box-outline"    label="KENTO"            :href="SB.current_kifu_vo.kento_url" target="_blank" @click="SB.other_app_click_handle('KENTO')")

        b-menu-list(label="棋譜再生用パーマリンク")
          b-menu-item.is_active_unset(icon="link-plus" label="棋譜URLコピー (短縮)" @click.prevent="SB.current_short_url_copy_handle" )
          b-menu-item.is_active_unset(icon="link" label="棋譜URLコピー" :href="SB.current_url" @click.prevent="SB.current_url_copy_handle" )

        b-menu-list(label="詰将棋・課題局面・変則手合割の作成")
          b-menu-item.is_active_unset(icon="import"             label="棋譜の読み込み" @click="SB.kifu_read_modal_open_handle()")
          b-menu-item.is_active_unset(icon="pencil-box-outline" label="局面編集"       @click="SB.edit_mode_set_handle")

        SbExport(:base="SB")
          b-menu-item.is_active_unset(icon="image" :label="`画像ダウンロード #${SB.current_turn}`" @click.native="SB.image_download_modal_handle")
          b-menu-item.is_active_unset(icon="movie" label="動画変換" @click.native="SB.video_new_handle")
          b-menu-item.is_active_unset(icon="mail" label="メール送信" @click.native="SB.kifu_mail_handle")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(icon="account-edit"   label="ハンドルネーム変更"   @click="SB.handle_name_modal_open_handle")
          b-menu-item.is_active_unset(icon="cat"            label="アバター設定"         @click="SB.avatar_input_modal_open_handle")
          b-menu-item.is_active_unset(icon="pencil-outline" label="タイトル変更"         @click="SB.title_edit_handle")

          b-menu-item.is_active_unset(icon="twitter" label="ツイートする"              @click="SB.tweet_modal_handle")
          //- b-menu-item.is_active_unset(icon="link"    label="ツイートリンクのコピー"    @click="SB.current_url_copy_handle")
          b-menu-item.is_active_unset(icon="help-circle-outline" label="使い方"                      @click="SB.general_help_modal_open_handle")
          b-menu-item.is_active_unset.is-hidden-mobile(icon="keyboard-outline" label="ショートカット"                      @click="SB.shortcut_modal_open_handle")
          b-menu-item.is_active_unset(icon="cog-outline" label="設定"                        @click="SB.general_setting_modal_open_handle")
          b-menu-item.is_active_unset(icon="bug-outline" label="デバッグ用ログ"              @click="SB.tl_modal_open_handle" v-if="development_p")
          b-menu-item.is_active_unset(icon="page-first" label="URLを開いたときの局面に戻す" @click="SB.reset_handle" :disabled="$GX.blank_p(SB.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(icon="help" tag="nuxt-link" :to="{name: 'experiment-OrderUiTest'}" label="手番検証" @click.native="sfx_click()" v-if="development_p")
      AppearanceUi.mt-5
      .box.mt-5
        b-field(label="音が出なくなったら？")
          b-button(@click="SB.audio_unlock_all_with_rooster") 音復活

      .box.mt-5(v-if="SB.debug_mode_p")
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

  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem

  .sidebar-content
    min-width: 20rem
    +mobile
      width: 90%
    +tablet
      width: 80%
    +desktop
      width: 50%
    +widescreen
      width: 50%
    +fullhd
      width: 50%

  .menu-label:not(:first-child), .SbExport
    margin-top: 2em

  .user_account
    img
      max-height: none
      height: 32px
      width: 32px
</style>
