<template lang="pug">
.XmovieForm2ColorTheme.one_block
  b-field(:label="base.ColorThemeInfo.field_label" :message="base.ColorThemeInfo.fetch(base.color_theme_key).message || base.ColorThemeInfo.field_message")
    .control
      b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play('click')")
        template(#trigger)
          b-button(:label="base.color_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.ColorThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key" @click="sound_play('click')")
              .media
                .media-left(v-html="e.name")
                  //- | {{e.name}}
                  //- | {{e.real_ext}}
                .media-content
                  //- .has-text-weight-bold {{e.name}}
                  //- h3 {{e.name}}
                  //- span {{e.message}}
                  //- | {{e.thumbnail_url(base)}}
                  //- b-img(:src="e.thumbnail_url(base)")
                  img.is-block(:src="e.thumbnail_url(base)")
                  //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                  //- small {{e.message}}

  // @click.native="sound_play('click')" すると2連続で呼ばれてしまうので指定してない
  // @click.native="toast_ok(1)" すると2回呼ばれていることがわかる
  b-field(message="FILE")
    //- (@input="base.upload_handle" @click.native="debug_alert('2回呼ばれる不具合があるため効果音OFF')")
    b-upload(type="is-white" v-model="base.bg_img_one_for_v_model" drag-drop @input="base.bg_img_one_file_upload_handle" native expanded accept="image/*")
      template(v-if="!base.bg_img_one")
        .section
          .content.has-text-centered
            p
              b-icon(icon="upload" size="is-medium")
            p
              //- | ファイルをドロップまたはクリックしてください
              //- br
              span.is-size-7
                | 2曲目があると開戦時に切り替わる
      template(v-else)
        figure.image.is-clickable
          img(:src="base.bg_img_one.url")
          .position_center
            b-icon.has-text-white(icon="camera" size="is-large")
          .position_top_left
            .size_info.is-size-7
              | 1200x630 推奨
          .position_bottom_right(v-if="base.bg_img_one")
            .icon_box(@click.prevent.stop="base.bg_img_one_delete_at")
              b-icon.has-text-white(icon="trash-can")

  b-field(message="FILE")
    b-upload(v-model="base.bg_img_one_for_v_model" drag-drop @input="base.bg_img_one_file_upload_handle" native expanded accept="image/*")
      .section
        .content.has-text-centered
          p
            b-icon(icon="upload" size="is-medium")
          p
            //- | ファイルをドロップまたはクリックしてください
            //- br
            span.is-size-7
              | 2曲目があると開戦時に切り替わる

  .box(v-if="base.bg_img_one")
    .media.is-justify-content-space-between
      //- .media-left
      .media-content
        b-image(:src="base.bg_img_one.url")
        | {{base.bg_img_one.attributes.name}}
      .media-right
        button.delete(size="is-small" @click="base.bg_img_one_delete_at" v-if="development_p")
        b-icon.is-clickable(icon="delete" @click.native="base.bg_img_one_delete_at" type="is-danger" size="is-small")
        b-button(icon-left="delete" size="is-small" @click="base.bg_img_one_delete_at" type="is-danger" v-if="development_p")

  .box(v-if="base.bg_img_one")
    .media.is-justify-content-space-between
      //- .media-left
      .media-content
        //- b-image(:src="base.bg_img_one.url")
        img(:src="base.bg_img_one.url")
        //- | {{base.bg_img_one.attributes.name}}
      .media-right
        button.delete(size="is-small" @click="base.bg_img_one_delete_at" v-if="development_p")
        b-icon.is-clickable(icon="delete" @click.native="base.bg_img_one_delete_at" type="is-danger" size="is-small")
        b-button(icon-left="delete" size="is-small" @click="base.bg_img_one_delete_at" type="is-danger" v-if="development_p")

</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieForm2ColorTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieForm2ColorTheme
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0

  .dropdown-item
    padding: 1.0rem
    +desktop
      min-width: 20rem
    .media
      align-items: center
      .media-left
        flex-basis: 50%

  .box
    // padding: 1.0rem
    // +desktop
    //   min-width: 20rem
    .media
      // align-items: center
      .media-content
        flex-basis: 50%

  .image
    // img
    //   +desktop
    //     width: calc(1200px * 0.5)
    //     height: calc(630px * 0.5)

    // 中央のカメラ
    .position_center
      position: absolute
      top: 0
      width: 100%
      height: 100%

      display: flex
      align-items: center
      justify-content: center
      flex-direction: column

      .icon
        filter: drop-shadow(0px 0px 12px rgba(0, 0, 0, 1.0))

    // "1200x630 推奨"
    .position_top_left
      position: absolute
      top: 0
      left: 0
      .size_info
        margin: 6px
        padding: 0.25rem 0.6rem
        color: $white
        background-color: change_color($black, $alpha: 0.6)
        font-weight: bold
        border-radius: 3px

    // 削除
    .position_bottom_right
      position: absolute
      bottom: 0
      right: 0
      .icon_box
        margin: 6px
        padding: 0.4rem 0.4rem 0.2rem
        background-color: change_color($black, $alpha: 0.6)
        border-radius: 3px
        .icon
          filter: drop-shadow(0px 0px 12px rgba(0, 0, 0, 1.0))

</style>
