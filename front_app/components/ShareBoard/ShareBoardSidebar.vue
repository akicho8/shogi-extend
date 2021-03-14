<template lang="pug">
b-sidebar.is-unselectable.ShareBoardApp-Sidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="リアルタイム共有")
          b-menu-item(label="合言葉の設定と共有"           @click="base.room_code_modal_handle")
          b-menu-item(label="対局時計の設置"               @click="base.cc_modal_handle")
          b-menu-item(label="合言葉だけを含むURLのコピー"  @click="base.room_code_url_copy_handle" :disabled="!base.room_code")
          b-menu-item(label="再接続(なんかおかしいとき用)" @click="base.room_recreate_handle"      :disabled="!base.connectable_p")

        b-menu-list(label="検討用")
          b-menu-item(label="ぴよ将棋" :href="base.piyo_shogi_app_with_params_url" :target="target_default" @click="sound_play('click')")
          b-menu-item(label="KENTO"    :href="base.kento_app_with_params_url"      :target="target_default" @click="sound_play('click')")
          b-menu-item(label="棋譜コピー" @click="base.kifu_cc_copy_handle('kif')")
        b-menu-list(label="編集・詰将棋作成")
          b-menu-item(label="局面編集"       @click="base.mode_toggle_handle")
          b-menu-item(label="棋譜の読み込み" @click="base.any_source_read_handle")
        b-menu-list(label="Export")
          b-menu-item(label="局面URLコピー"                                                        @click="base.current_url_cc_copy_handle")
          b-menu-item(label="SFEN コピー"                                                          @click="base.kifu_cc_copy_handle('sfen')")
          b-menu-item(label="BOD コピー"                                                          @click="base.kifu_cc_copy_handle('bod')")
          b-menu-item(label="KIF ダウンロード"             :href="base.kif_download_url"           @click="sound_play('click')")
          b-menu-item(label="KIF ダウンロード (Shift_JIS)" :href="base.shift_jis_kif_download_url" @click="sound_play('click')")
          b-menu-item(label="画像ダウンロード"             :href="base.snapshot_image_url"         @click="sound_play('click')")
        b-menu-list(label="その他")
          b-menu-item(label="OGP画像の視点設定"             @click="base.abstract_viewpoint_setting_handle")
          b-menu-item(label="局面URLツイート(合言葉を含む)" @click="base.tweet_handle")
          b-menu-item(label="タイトル変更"                  @click="base.title_edit")
          b-menu-item(label="URLを開いたときの局面に戻す"   @click="base.reset_handle")

      .box.mt-5
        .title.is-5 スタイル設定
        b-field(custom-class="is-small" label="盤の大きさ(スマホを除く)")
          b-slider(v-bind="slider_attrs" v-model="base.share_board_column_width" :min="0" :max="100" :step="0.1")
      .box.mt-5
        .title.is-5 ☠危険な設定
        b-field(custom-class="is-small" label="将棋のルール" message="無視にすると「自分の手番では自分の駒を操作する」の制約を無視するので、自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせば見た目上はずっと先手側を操作できるので先手だけの囲いの手順の棋譜を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう")
          b-radio-button(size="is-small" v-model="base.internal_rule" native-value="strict" @input="base.internal_rule_input_handle") 守る
          b-radio-button(size="is-small" v-model="base.internal_rule" native-value="free"   @input="base.internal_rule_input_handle" type="is-danger") 無視

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

.ShareBoardApp-Sidebar
  .sidebar-content
    width: 20rem
  .menu-label
    margin-top: 2em

  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px
</style>
