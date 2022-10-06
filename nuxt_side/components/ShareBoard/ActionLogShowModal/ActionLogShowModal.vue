<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面 \#{{new_turn}}
  .modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_summary="is_summary_off"
        sp_run_mode="view_mode"
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_layout="is_horizontal"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        :sp_view_mode_soldier_movable="false"
        :sp_viewpoint="sp_viewpoint"
        :sp_turn="action_log.turn"
        :sp_body="action_log.sfen"
        @update:turn_offset="v => new_turn = v"
      )
    .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
      PiyoShogiButton(:href="piyo_shogi_app_with_params_url" @click="base.other_app_click_handle('ぴよ将棋')")
      KentoButton(tag="a" :href="kento_app_with_params_url" target="_blank" @click="base.other_app_click_handle('KENTO')")
      KifCopyButton(@click="kifu_copy_handle") コピー

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button.room_code_except_url_copy_handle(
        title="棋譜再生用リンク"
        @click.prevent="room_code_except_url_copy_handle"
        icon-left="link"
        tag="a"
        :href="room_code_except_url"
        )
      b-button.kifu_download_handle(
        title="ダウンロード"
        @click.prevent="kifu_download_handle(current_format_type_info)"
        icon-left="download"
        tag="a"
        :href="kifu_download_url(current_format_type_info)"
        )
      b-button.kifu_show_handle(
        title="棋譜表示"
        @click.prevent="kifu_show_handle(current_format_type_info)"
        icon-left="eye-outline"
        tag="a"
        :href="kifu_show_url(current_format_type_info)"
        )

    pre.mt-4(v-if="base.debug_mode_p") {{pretty_inspect(action_log)}}

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.apply_button(@click="apply_handle" type="is-primary") {{new_turn}}手目まで戻る
</template>

<script>
import { support_child } from "../support_child.js"
import { app_urls } from "./app_urls.js"

export default {
  name: "ActionLogShowModal",
  mixins: [
    support_child,
    app_urls,
  ],
  props: {
    action_log: { type: Object, required: true, },
  },
  data() {
    return {
      new_turn: this.action_log.turn,
      sp_viewpoint: this.base.sp_viewpoint, // メイン将棋盤の視点を初期値とする
    }
  },
  mounted() {
    this.__assert__(this.sp_viewpoint === "white" || this.sp_viewpoint === "black")
    this.__assert__('sfen' in this.action_log, "'sfen' in this.action_log")
    this.__assert__('turn' in this.action_log, "'turn' in this.action_log")
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.$sound.play_click()
      this.base.action_log_jump({...this.action_log, turn: this.new_turn})
      this.$emit("close")
    },
  },
  computed: {
    current_format_type_info() {
      return this.base.FormatTypeInfo.fetch("kif_utf8")
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActionLogShowModal
  +modal_width(512px)

  .modal-card-body
    padding: 1.25rem
    .buttons > *
      margin-bottom: 0

.STAGE-development
  .ActionLogShowModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
