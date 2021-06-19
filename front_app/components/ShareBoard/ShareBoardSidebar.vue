<template lang="pug">
b-sidebar.is-unselectable.ShareBoardSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
      template(v-if="!base.self_is_member_p")
        NavbarItemLogin(component="a")
        NavbarItemProfileLink(component="a")

    .mt-4
      b-menu
        b-menu-list(label="リアルタイム共有")
          b-menu-item.is_active_unset(label="部屋に入る" @click="base.room_setup_modal_handle")
          b-menu-item.is_active_unset(label="順番設定"   @click="base.os_modal_handle" :disabled="blank_p(base.ac_room)")
          b-menu-item.is_active_unset(label="対局時計"   @click="base.cc_modal_handle")

        b-menu-list(label="共有サポート")
          b-menu-item.is_active_unset(label="初期配置に戻す"              @click="base.board_init_modal_handle")
          b-menu-item.is_active_unset(label="1手戻す"                     @click="base.force_sync_turn_previous_modal_handle")
          b-menu-item.is_active_unset(label="局面の転送"                  @click="base.force_sync_modal_handle"    :disabled="blank_p(base.ac_room)")
          b-menu-item.is_active_unset(label="手合割"                      @click="base.handicap_set_modal_handle")
          b-menu-item.is_active_unset(label="合言葉だけを含むURLのコピー" @click="base.room_code_only_url_copy_handle"  :disabled="blank_p(base.ac_room)")
          b-menu-item.is_active_unset(label="自動マッチング"              @click="base.xmatch_modal_handle" v-if="$config.STAGE !== 'production' || true")
          b-menu-item.is_active_unset(label="再起動"                      @click="base.room_recreate_modal_handle" :disabled="blank_p(base.ac_room)")

        b-menu-list(label="あとで検討")
          //- b-menu-item.is_active_unset(label="ぴよ将棋" :href="base.piyo_shogi_app_with_params_url" :target="target_default" @click="sound_play('click')")
          //- b-menu-item.is_active_unset(label="KENTO"    :href="base.kento_app_with_params_url"      :target="target_default" @click="sound_play('click')")
          b-menu-item.is_active_unset(label="ぴよ将棋" :href="base.piyo_shogi_app_with_params_url" :target="target_default" @click="base.other_app_click_handle('ぴよ将棋')")
          b-menu-item.is_active_unset(label="KENTO"    :href="base.kento_app_with_params_url"      :target="target_default" @click="base.other_app_click_handle('KENTO')")
          b-menu-item.is_active_unset(label="棋譜コピー" @click="base.kifu_copy_handle(base.FormatTypeInfo.fetch('kif'))")
          b-menu-item.is_active_unset(label="棋譜だけを含むURLのコピー" @click="base.room_code_except_url_copy_handle")

        b-menu-list(label="編集・詰将棋作成")
          b-menu-item.is_active_unset(label="局面編集"       @click="base.edit_mode_handle")
          b-menu-item.is_active_unset(label="棋譜の読み込み" @click="base.any_source_read_handle")

        b-menu-list(label="Twitter")
          b-menu-item.is_active_unset(label="ツイートする"                @click="base.tweet_modal_handle")
          b-menu-item.is_active_unset(label="ツイートURLのコピー"         @click="base.current_url_copy_handle")
          b-menu-item.is_active_unset(label="ツイート画像の視点設定"      @click="base.abstract_viewpoint_setting_handle")

        ShareBoardSidebarExport(:base="base")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(label="ハンドルネーム変更"          @click="base.handle_name_modal_handle" :disabled="present_p(base.ac_room)")
          b-menu-item.is_active_unset(label="タイトル変更"                @click="base.title_edit_handle")
          b-menu-item.is_active_unset(label="使い方"                      @click="base.general_help_modal_handle")
          b-menu-item.is_active_unset(label="設定"                        @click="base.general_setting_modal_handle")
          b-menu-item.is_active_unset(label="URLを開いたときの局面に戻す" @click="base.reset_handle" :disabled="blank_p(base.ac_room)" v-if="development_p")
          b-menu-item.is_active_unset(label="デバッグ用ログ"              @click="base.tl_modal_handle" v-if="development_p")

      .style_container.box.mt-5
        .title.is-5 スタイル設定
        b-field(custom-class="is-small" label="盤の大きさ")
          b-slider(v-bind="slider_attrs" v-model="base.share_board_column_width" :min="0" :max="100" :step="1.0")

      //- .box.mt-5(v-if="false")
      //-   .title.is-5 ☠危険な設定
      //-   b-field(custom-class="is-small" label="将棋のルール" message="無視にすると「自分の手番では自分の駒を操作する」の制約を無視するので、自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせば見た目上はずっと先手側を操作できるので先手だけの囲いの手順の棋譜を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう")
      //-     b-radio-button(size="is-small" v-model="base.internal_rule" native-value="strict" @input="base.internal_rule_input_handle") 守る
      //-     b-radio-button(size="is-small" v-model="base.internal_rule" native-value="free"   @input="base.internal_rule_input_handle" type="is-danger") 無視

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardSidebar",
  mixins: [support_child],
  computed: {
    slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardSidebar
  .sidebar-content
    width: 20rem

  .menu-label
    margin-top: 2em

  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px

  .style_container
    +mobile
      display: none

  .user_account
    img
      max-height: none
      height: 32px
      width: 32px
</style>
