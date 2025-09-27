<template lang="pug">
//- https://buefy.org/documentation/sidebar
b-sidebar.is-unselectable.SbSidebar(fullheight right overlay v-model="SB.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      NavbarItemSidebarClose(@click="SB.sidebar_toggle")
      template(v-if="$gs.blank_p(SB.ac_room) || !SB.i_am_member_p")
        NavbarItemLogin(component="a")
        NavbarItemProfileLink(component="a" :click_fn="SB.profile_click_handle")
    .mt-4
      b-menu
        .main_procedure
          b-menu-list(label="対局手順")
            .buttons.is-centered.mb-0
              b-button.mb-0.is_active_unset.important.rsm_open_handle(rounded expanded :class="SB.bold_if(mi1_bold_p)" @click="SB.rsm_open_handle")
                .number_with_label
                  b-icon(icon="numeric-1-circle-outline")
                  | 入退室
                  b-icon(size="is-small" icon="arrow-left-bold" v-if="SB.debug_mode_p && mi1_hand_p")
                .check_mark(v-if="SB.bold_if(mi1_bold_p)") ✅
              b-button.mb-0.is_active_unset.important.os_modal_open_handle(rounded expanded :class="SB.bold_if(mi2_bold_p)" @click="SB.os_modal_open_handle")
                .number_with_label
                  b-icon(icon="numeric-2-circle-outline")
                  | 順番設定
                  b-icon(size="is-small" icon="arrow-left-bold" v-if="SB.debug_mode_p && mi2_hand_p")
                .check_mark(v-if="SB.bold_if(mi2_bold_p)") ✅
              b-button.mb-0.is_active_unset.important.cc_modal_open_handle(rounded expanded :class="SB.bold_if(mi3_bold_p)" @click="SB.cc_modal_open_handle")
                .number_with_label
                  b-icon(icon="numeric-3-circle-outline")
                  | 対局時計
                  b-icon(size="is-small" icon="arrow-left-bold" v-if="SB.debug_mode_p && mi3_hand_p")
                .check_mark(v-if="SB.bold_if(mi3_bold_p)") ✅

        b-menu-list(label="局面操作")
          b-menu-item.is_active_unset(icon="page-first"  label="初期配置に戻す"   @click="SB.turn_change_to_zero_modal_open_handle" :class="SB.bold_if(SB.current_turn >= 1)")
          b-menu-item.is_active_unset(icon="undo"        label="1手戻す (待った)" @click="SB.turn_change_to_previous_modal_open_handle")
          b-menu-item.is_active_unset(icon="transfer-up" label="局面の転送"       @click="SB.force_sync_modal_handle" v-if="SB.quick_sync_info.sidebar_function_show || SB.debug_mode_p")

        b-menu-list(label="対局サポート")
          b-menu-item.is_active_unset(icon="scale-balance"          label="手合割"               @click="SB.preset_select_modal_open_handle")
          b-menu-item.is_active_unset(icon="link"                   label="部屋のリンクのコピー" @click="SB.room_url_copy_handle")
          b-menu-item.is_active_unset(icon="heart"                  label="自動マッチング"       @click="SB.xmatch_modal_handle" v-if="$config.STAGE !== 'production'")
          b-menu-item.is_active_unset(icon="restart"                label="再起動"               @click="SB.room_recreate_modal_handle" v-if="SB.debug_mode_p")
          b-menu-item.is_active_unset(icon="home" label="対局履歴" @click="SB.general_dashboard_modal_handle" :disabled="$gs.blank_p(SB.ac_room)")
          b-menu-item.is_active_unset(icon="trophy" tag="nuxt-link" label="対局履歴(nuxt-link)" :to="{name: 'share-board-dashboard', query: {room_key: SB.room_key}}" @click.native="sfx_play_click()" :disabled="$gs.blank_p(SB.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(icon="trophy" label="対局履歴(hrefで別タブ)" :href="SB.dashboard_url" target="_blank" :disabled="$gs.blank_p(SB.ac_room)" v-if="development_p")

        b-menu-list(label="検討")
          b-menu-item.is_active_unset(icon="clipboard-plus-outline" label="棋譜コピー (KIF)" @click="SB.kifu_copy_handle('kif_utf8')")
          b-menu-item.is_active_unset(icon="duck"                   label="ぴよ将棋"         :href="SB.current_kifu_vo.piyo_url"  :target="target_default" @click="SB.other_app_click_handle('ぴよ将棋')" v-if="$PiyoShogiTypeCurrent.info.showable_p || SB.debug_mode_p")
          b-menu-item.is_active_unset(icon="alpha-k-box-outline"    label="KENTO"            :href="SB.current_kifu_vo.kento_url" target="_blank" @click="SB.other_app_click_handle('KENTO')")

        b-menu-list(label="棋譜再生用パーマリンク")
          b-menu-item.is_active_unset(icon="link-plus" label="棋譜URLコピー (短縮)" @click.prevent="SB.current_short_url_copy_handle" )
          b-menu-item.is_active_unset(icon="link" label="棋譜URLコピー" :href="SB.current_url" @click.prevent="SB.current_url_copy_handle" )

        b-menu-list(label="詰将棋・課題局面・変則手合割の作成")
          b-menu-item.is_active_unset(icon="pencil-box-outline" label="局面編集"       @click="SB.edit_mode_handle")
          b-menu-item.is_active_unset(icon="import"             label="棋譜の入力" @click="SB.yomikomi_modal_open_handle()")

        SbSidebarExport(:base="SB")
          b-menu-item.is_active_unset(icon="image" :label="`画像ダウンロード #${SB.current_turn}`" @click.native="SB.image_dl_modal_handle")
          b-menu-item.is_active_unset(icon="movie" label="動画変換" @click.native="SB.video_new_handle")
          b-menu-item.is_active_unset(icon="mail" label="メール送信" @click.native="SB.kifu_mail_handle")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(icon="twitter" label="ツイートする"              @click="SB.tweet_modal_handle")
          //- b-menu-item.is_active_unset(icon="link"    label="ツイートリンクのコピー"    @click="SB.current_url_copy_handle")
          b-menu-item.is_active_unset(icon="help-circle-outline" label="使い方"                      @click="SB.general_help_modal_handle")
          b-menu-item.is_active_unset(icon="pencil-outline" label="タイトル変更"                @click="SB.title_edit_handle")
          b-menu-item.is_active_unset(icon="account-edit" label="ハンドルネーム変更"          @click="SB.handle_name_modal_handle")
          b-menu-item.is_active_unset.is-hidden-mobile(icon="keyboard-outline" label="ショートカット"                      @click="SB.shortcut_modal_open_handle")
          b-menu-item.is_active_unset(icon="cog-outline" label="設定"                        @click="SB.general_setting_modal_open_handle")
          b-menu-item.is_active_unset(icon="bug-outline" label="デバッグ用ログ"              @click="SB.tl_modal_handle" v-if="development_p")
          b-menu-item.is_active_unset(icon="page-first" label="URLを開いたときの局面に戻す" @click="SB.reset_handle" :disabled="$gs.blank_p(SB.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(icon="help" tag="nuxt-link" :to="{name: 'experiment-OrderUiTest'}" label="手番検証" @click.native="sfx_play_click()" v-if="development_p")
      AppearanceUi.mt-5
      .box.mt-5
        b-field(label="音が出なくなったとき用")
          b-button(@click="SB.sound_resume_all_with_rooster") 音復活

      .box.mt-5(v-if="SB.debug_mode_p")
        b-field(:label="`バッジ数調整 (${SB.acquire_badge_count})`")
          .control
            b-button(@click="SB.badge_add_to_self_handle(-1)") -1
          .control
            b-button(@click="SB.badge_add_to_self_handle(1)") +1
        pre(v-if="SB.debug_mode_p")
          | {{SB.badge_counts_hash}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbSidebar",
  mixins: [support_child],
  computed: {
    mi1_bold_p() { return this.SB.ac_room                                                                 },
    mi1_hand_p() { return !this.SB.ac_room                                                                },
    mi2_bold_p() { return this.SB.ac_room && this.SB.order_enable_p && this.SB.order_unit.valid_p     },
    mi2_hand_p() { return this.SB.ac_room && (!this.SB.order_enable_p || !this.SB.order_unit.valid_p) },
    mi3_bold_p() { return this.mi2_bold_p && this.SB.clock_box                                            },
    mi3_hand_p() { return this.mi2_bold_p && !this.SB.clock_box                                           },
  },
}
</script>

<style lang="sass">
@import "./sass/support.sass"

.SbSidebar
  .sidebar-content
    width: 20rem

  .menu-label:not(:first-child), .SbSidebarExport
    margin-top: 2em

  .user_account
    img
      max-height: none
      height: 32px
      width: 32px

  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem

  .important
    font-size: $size-5

  .main_procedure
    .buttons
      gap: 0.5rem               // ボタン同士の隙間
      .button
        padding: 0.5rem 1.25rem 0.5rem 0.75rem // ボタン内の隙間
        // .button 内のアイコンは位置を微調整されているためリセットする
        .icon
          margin-right: 0
          margin-left: 0
          line-height: 1.0
        > span // button 中身は span で囲まれている
          display: flex
          align-items: center
          justify-content: space-between
          flex-grow: 1          // 横幅最大化
          .number_with_label
            display: flex
            gap: 0.4rem         // 番号とラベルの隙間
</style>
