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
    b-upload(v-model="base.ximage_list_for_v_model" multiple drag-drop @input="base.ximage_file_upload_handle" native accept="image/*")
      .is-flex.is-align-items-center.px-3.py-1
        b-icon(icon="upload" size="is-small")
        .is-size-7.ml-2 背景画像のアップロード

  .box(v-if="base.ximage_list.length >= 1")
    .media.is-justify-content-space-between(v-for="(file, index) in base.ximage_list" :key="index")
      .media-left
        img(:src="file.url")
        //- .position_filename(v-if="development_p")
        //-   .size_info.is-size-7
        //-     | {{file.attributes.name}}
        //- .position_trash_icon(v-if="file")
        //-   .icon_box.is-clickable(@click.prevent.stop="base.ximage_one_delete_handle")
        //-     b-icon.has-text-white(icon="trash-can")

        //- XmovieAudioPlay(:base="base" :src="file.url" @play="e => base.current_play_instance = e" v-if="file.url")
      .media-content
        | {{file.attributes.name}}
      .media-right
        button.delete(size="is-small" @click="base.ximage_list_delete_at(index)" v-if="development_p")
        b-icon.is-clickable(icon="delete" @click.native="base.ximage_list_delete_at(index)" type="is-danger" size="is-small")
        b-button(icon-left="delete" size="is-small" @click="base.ximage_list_delete_at(index)" type="is-danger" v-if="development_p")

  //- template(v-if="base.ximage_list")
  //-   figure.image
  //-     img(:src="base.ximage_list.url")
  //-     .position_filename(v-if="development_p")
  //-       .size_info.is-size-7
  //-         | {{base.ximage_list.attributes.name}}
  //-     .position_trash_icon(v-if="base.ximage_list")
  //-       .icon_box.is-clickable(@click.prevent.stop="base.ximage_one_delete_handle")
  //-         b-icon.has-text-white(icon="trash-can")
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
    .media
      height: 4rem
      .media-left
        height: 100%
        flex: 0 1 25%           // 伸:X 縮:O
        img
          max-height: 100%      // 縦長画像がはみでるのを防ぐ
      .media-left, .media-content, .media-right
        height: 100%
        display: flex
        align-items: center
      .media-left, .media-right
        justify-content: center
        // ↑メモする



      // .media-content
      //   flex-basis: 50%
      //   // width: 64px

  // .image
  //   img
  //     border: 1px solid $grey-lighter // videoの枠と合わせる
  //     border-radius: 4px              // videoの枠と合わせる
  //
  //   // ファイル名の表示
  //   .position_filename
  //     position: absolute
  //     top: 0
  //     left: 0
  //     .size_info
  //       margin: 6px
  //       padding: 0.25rem 0.6rem
  //       color: $white
  //       background-color: change_color($black, $alpha: 0.4)
  //       font-weight: bold
  //       border-radius: 3px
  //
  //   // 削除
  //   .position_trash_icon
  //     position: absolute
  //     top: 0
  //     right: 0
  //     .icon_box
  //       margin: 6px
  //       padding: 0.4rem 0.4rem 0.2rem
  //       background-color: change_color($black, $alpha: 0.4)
  //       border-radius: 3px
  //       .icon
  //         filter: drop-shadow(0px 0px 12px rgba(0, 0, 0, 1.0))
</style>
