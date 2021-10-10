<template lang="pug">
.KiwiBananaShowMain.columns.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
  .column.is-12-tablet.is-10-desktop.is-8-widescreen
    .block.CustomShogiPlayerGround(v-show="base.show_mode === 'is_board'")
      .CustomShogiPlayerPosition
        CustomShogiPlayer.is_mobile_vertical_good_style(
          ref="main_sp"
          :sp_body="base.banana.advanced_kif_info.body"
          :sp_turn="base.banana.advanced_kif_info.turn"
          sp_run_mode="view_mode"
          :sp_sound_enabled="true"
          sp_summary="is_summary_off"
          sp_controller="is_controller_on"
          sp_slider="is_slider_on"
        )
    .block(v-show="base.show_mode === 'is_video'")
      template(v-if="content_type")
        template(v-if="content_type.startsWith('video')")
          .image
            video.is-block(:src="base.banana.lemon.browser_path" controls :autoplay="true" :loop="false" ref="main_video")
            //- video.is-block(:src="base.banana.lemon.browser_path" :poster="base.banana.lemon.thumbnail_browser_path" controls :autoplay="true" :loop="false" ref="main_video")
        template(v-else-if="content_type.startsWith('image')")
          .image
            img(:src="base.banana.lemon.browser_path")
        template(v-else-if="content_type === 'application/zip'")
          b-icon(icon="zip-box-outline" size="is-large")

    .media
      .media-left
        nuxt-link.image.is_avatar_image(:to="{name: 'users-id', params: {id: base.banana.user.id}}" @click.native="sound_play('click')")
          img.is-rounded(:src="base.banana.user.avatar_path" :alt="base.banana.user.name")

      .media-content
        .title.is_line_break_on.mb-0.is-5 {{base.banana.title}}
        .nav_line
          .nav_line_left.is_line_break_on.has-text-grey
            nuxt-link(:to="{name: 'users-id', params: {id: base.banana.user.id}}" @click.native="sound_play('click')")
              | {{base.banana.user.name}}

            //- span.ml-1 {{updated_time_format(base.banana.updated_at)}}
            span.ml-3 {{diff_time_format(base.banana.updated_at)}}

            b-icon.ml-3(icon="eye-outline" size="is-small")
            span.ml-1 {{base.banana.access_logs_count}}

            b-icon.ml-3(icon="comment-outline" size="is-small")
            span.ml-1 {{base.banana.banana_messages_count}}

            b-icon.ml-3(:icon="base.banana.folder_info.icon" size="is-small" v-if="base.banana.folder_info.key != 'public'")
          .nav_line_right
            b-button.switch_handle(icon-left="hand-pointing-up" @click="base.switch_handle")

        KiwiTagList.mt-2(:tag_list="base.banana.tag_list" :tag_click_handle="base.tag_click_handle")
        .content.mt-1(v-if="base.banana.description")
          .description(v-html="base.message_decorate(base.banana.description)")

  .column
     KiwiBananaShowMessage(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowMain",
  mixins: [support_child],
  mounted() {
    this.__assert__(this.present_p(this.base.banana), "this.present_p(this.base.banana)")
    // if (this.$refs.main_video) {
    //   this.$refs.main_video.play()
    // }
  },
  computed: {
    content_type() { return this.base.banana.lemon.content_type },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowMain
  .CustomShogiPlayerGround
    display: flex
    align-items: center
    justify-content: center
    width: 100%
    .CustomShogiPlayerPosition
      width: 100%
      +tablet
        width: 70%
      +desktop
        width: 65%
      +widescreen
        width: 60%
      +fullhd
        width: 55%

  .is_avatar_image
    width: 32px
    +tablet
      width: 48px
  .nav_line
    display: flex
    align-items: center
    justify-content: space-between
    line-height: 2.5rem

.x-STAGE-development
  .KiwiBananaShowMain
    .media
      border: 1px solid change_color($danger, $alpha: 0.5)
      .media-left
        border: 1px dashed change_color($primary, $alpha: 0.5)
      .media-content
        border: 1px dashed change_color($primary, $alpha: 0.5)
      .media-right
        border: 1px dashed change_color($primary, $alpha: 0.5)

    .nav_line, .nav_line_right, .nav_line_left
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
