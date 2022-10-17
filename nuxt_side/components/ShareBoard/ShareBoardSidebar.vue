<template lang="pug">
b-sidebar.is-unselectable.ShareBoardSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
      template(v-if="blank_p(base.ac_room) || !base.self_is_member_p")
        NavbarItemLogin(component="a")
        NavbarItemProfileLink(component="a" :click_fn="base.profile_click_handle")
    .mt-4
      b-menu
        // 元のアイコン
        // 1. home-account
        // 2. sort-bool-ascending
        // 3. alarm

        b-menu-list(label="対局手順")

          b-menu-item.is_active_unset.important.room_setup_modal_handle(:class="base.bold_if(mi1_bold_p)" icon="numeric-1-circle-outline" @click="base.room_setup_modal_handle")
            template(#label)
              | 部屋に入る
              b-icon.is_hand_blink(size="is-small" icon="arrow-left-bold" v-if="mi1_hand_p")

          b-menu-item.is_active_unset.important.os_modal_handle(:class="base.bold_if(mi2_bold_p)" icon="numeric-2-circle-outline" @click="base.os_modal_handle")
            template(#label)
              | 順番設定
              b-icon.is_hand_blink(size="is-small" icon="arrow-left-bold" v-if="mi2_hand_p")

          b-menu-item.is_active_unset.important.cc_modal_handle(:class="base.bold_if(mi3_bold_p)" icon="numeric-3-circle-outline" @click="base.cc_modal_handle")
            template(#label)
              | 対局時計
              b-icon.is_hand_blink(size="is-small" icon="arrow-left-bold" v-if="mi3_hand_p")

        b-menu-list(label="局面操作")
          b-menu-item.is_active_unset(icon="undo"        label="1手戻す"        @click="base.force_sync_turn_previous_modal_handle")
          b-menu-item.is_active_unset(icon="page-first"  label="初期配置に戻す" @click="base.board_init_modal_handle")
          b-menu-item.is_active_unset(icon="transfer-up" label="局面の転送"     @click="base.force_sync_modal_handle" v-if="base.quick_sync_info.sidebar_function_show || base.debug_mode_p")

        b-menu-list(label="対局サポート")
          b-menu-item.is_active_unset(icon="scale-balance"          label="手合割"               @click="base.board_preset_select_modal_handle")
          b-menu-item.is_active_unset(icon="link"                   label="部屋のリンクのコピー" @click="base.room_code_only_url_copy_handle")
          b-menu-item.is_active_unset(icon="heart"                  label="自動マッチング"       @click="base.xmatch_modal_handle" v-if="$config.STAGE !== 'production' || true")
          b-menu-item.is_active_unset(icon="restart"                label="再起動"               @click="base.room_recreate_modal_handle" v-if="base.debug_mode_p")

        b-menu-list(label="検討")
          //- b-menu-item.is_active_unset(label="ぴよ将棋" :href="base.piyo_shogi_app_with_params_url" :target="target_default" @click="$sound.play_click()")
          //- b-menu-item.is_active_unset(label="KENTO"    :href="base.kento_app_with_params_url"      :target="target_default" @click="$sound.play_click()")
          b-menu-item.is_active_unset(icon="clipboard-plus-outline" label="棋譜コピー (KIF)" @click="base.kifu_copy_handle(base.FormatTypeInfo.fetch('kif_utf8'))")
          b-menu-item.is_active_unset(icon="duck"                   label="ぴよ将棋"         :href="base.piyo_shogi_app_with_params_url" :target="target_default" @click="base.other_app_click_handle('ぴよ将棋')")
          b-menu-item.is_active_unset(icon="alpha-k-box-outline"    label="KENTO"            :href="base.kento_app_with_params_url"      target="_blank" @click="base.other_app_click_handle('KENTO')")

        b-menu-list(label="棋譜再生用パーマリンク")
          b-menu-item.is_active_unset(icon="link" label="棋譜URLコピー" :href="base.room_code_except_url" @click.prevent="base.room_code_except_url_copy_handle" )
          b-menu-item.is_active_unset(icon="link-plus" label="棋譜URLコピー (短縮)" @click.prevent="base.room_code_except_url_short_copy_handle" )

        b-menu-list(label="詰将棋・課題局面・変則手合割の作成")
          b-menu-item.is_active_unset(icon="import"             label="棋譜の読み込み" @click="base.yomikomi_modal_open_handle")
          b-menu-item.is_active_unset(icon="pencil-box-outline" label="局面編集"       @click="base.edit_mode_handle")

        b-menu-list(label="SNS共有")
          b-menu-item.is_active_unset(icon="twitter" label="ツイートする"              @click="base.tweet_modal_handle")
          b-menu-item.is_active_unset(icon="link"    label="ツイートリンクのコピー"    @click="base.current_url_copy_handle")
          b-menu-item.is_active_unset(icon="eye"     label="ツイート画像の視点設定"    @click="base.abstract_viewpoint_key_select_modal_handle")

        ShareBoardSidebarExport(:base="base")
          b-menu-item.is_active_unset(icon="image" :label="`画像ダウンロード #${base.current_turn}`" @click.native="base.image_dl_modal_handle")
          b-menu-item.is_active_unset(icon="movie" label="動画変換" @click.native="base.video_new_handle")
          b-menu-item.is_active_unset(icon="mail" label="メール送信" @click.native="base.kifu_mail_handle")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(icon="help-circle-outline" label="使い方"                      @click="base.general_help_modal_handle")
          b-menu-item.is_active_unset(icon="pencil-outline" label="タイトル変更"                @click="base.title_edit_handle")
          b-menu-item.is_active_unset(icon="account-edit" label="ハンドルネーム変更"          @click="base.handle_name_modal_handle")
          b-menu-item.is_active_unset(icon="cog-outline" label="設定"                        @click="base.general_setting_modal_handle")
          b-menu-item.is_active_unset(icon="bug-outline" label="デバッグ用ログ"              @click="base.tl_modal_handle" v-if="development_p")
          b-menu-item.is_active_unset(icon="page-first" label="URLを開いたときの局面に戻す" @click="base.reset_handle" :disabled="blank_p(base.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(icon="help" tag="nuxt-link" :to="{name: 'experiment-OrderUiTest'}" label="手番検証" @click.native="$sound.play_click()" v-if="development_p")
      .box.mt-5
        .title.is-6 スタイル設定
        SimpleSlider.is-hidden-touch(:base="base" label="盤の大きさ" var_name="board_width" :min="60" :max="100" :step="1.0")
        SimpleRadioButtons(:base="base" model_name="AppearanceThemeInfo" var_name="appearance_theme_key" custom-class="is-small")

      .box.mt-5
        b-field(label="音が出なくなったとき用")
          b-button(@click="base.sound_resume_all_with_rooster") 音復活
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardSidebar",
  mixins: [support_child],
  computed: {
    mi1_bold_p() { return this.base.ac_room                                                                 },
    mi1_hand_p() { return !this.base.ac_room                                                                },
    mi2_bold_p() { return this.base.ac_room && this.base.order_enable_p && this.base.order_unit.valid_p     },
    mi2_hand_p() { return this.base.ac_room && (!this.base.order_enable_p || !this.base.order_unit.valid_p) },
    mi3_bold_p() { return this.mi2_bold_p && this.base.clock_box                                            },
    mi3_hand_p() { return this.mi2_bold_p && !this.base.clock_box                                           },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardSidebar
  .sidebar-content
    width: 20rem

  .menu-label:not(:first-child), .ShareBoardSidebarExport
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
</style>
