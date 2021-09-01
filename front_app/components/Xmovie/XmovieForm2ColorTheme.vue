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
                .media-content
                  img.is-block(:src="e.thumbnail_url(base)")
  b-field
    b-upload(v-model="base.bg_img_one_for_v_model" @input="base.bg_img_one_file_upload_handle" drag-drop native accept="image/*")
      .is-flex.is-align-items-center.px-3.py-1
        b-icon(icon="upload" size="is-small")
        .is-size-7.ml-2 背景画像のアップロード
  template(v-if="base.bg_img_one")
    figure.image
      img(:src="base.bg_img_one.url")
      .position_filename(v-if="development_p")
        .size_info.is-size-7
          | {{base.bg_img_one.attributes.name}}
      .position_trash_icon(v-if="base.bg_img_one")
        .icon_box.is-clickable(@click.prevent.stop="base.bg_img_one_delete_at")
          b-icon.has-text-white(icon="trash-can")
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
    img
      border: 1px solid $grey-lighter // videoの枠と合わせる
      border-radius: 4px              // videoの枠と合わせる

    // ファイル名の表示
    .position_filename
      position: absolute
      top: 0
      left: 0
      .size_info
        margin: 6px
        padding: 0.25rem 0.6rem
        color: $white
        background-color: change_color($black, $alpha: 0.4)
        font-weight: bold
        border-radius: 3px

    // 削除
    .position_trash_icon
      position: absolute
      top: 0
      right: 0
      .icon_box
        margin: 6px
        padding: 0.4rem 0.4rem 0.2rem
        background-color: change_color($black, $alpha: 0.4)
        border-radius: 3px
        .icon
          filter: drop-shadow(0px 0px 12px rgba(0, 0, 0, 1.0))
</style>
