<template lang="pug">
.XconvForm2AudioTheme
  b-field.main_field(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message")
    .control
      b-dropdown(v-model="base.audio_theme_key" @active-change="base.active_change_handle")
        template(#trigger)
          b-button(:label="base.audio_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.AudioThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key" @click="sound_play('click')")
              .media
                .media-left
                  b-button.is-invisible(v-if="!e.sample_m4a" icon-left="blank" size="is-small" type="is-ghost")
                  XconvAudioPlay(:base="base" :src="e.sample_m4a" size="is-small" v-if="e.sample_m4a" @play="e => base.current_play_instance = e")
                .media-content
                  | {{e.name}}

  b-field(v-if="base.audio_theme_info.key === 'audio_theme_user' || development_p" message="")
    b-upload(v-model="base.audio_list_for_v_model" multiple drag-drop @input="base.audio_file_upload_handle" native expanded accept="audio/*")
      .section
        .content.has-text-centered
          p
            b-icon(icon="upload" size="is-large")
          p
            | ファイルをドロップまたはクリックしてください
            br
            span.is-size-7
              | 2曲目があると開戦時に切り替わる

  .box(v-if="base.audio_list.length >= 1")
    .media(v-for="(file, index) in base.audio_list" :key="index")
      .media-left
        XconvAudioPlay(:base="base" :src="file.data_url" size="is-small" @play="e => base.current_play_instance = e" v-if="file.data_url")
      .media-content
        | {{file.name}}
      .media-right
        button.delete(size="is-small" @click="base.audio_list_delete_at(index)")
        b-icon.is-clickable(icon="delete" @click.native="base.audio_list_delete_at(index)" type="is-danger" size="is-small")
        b-button(icon-left="delete" size="is-small" @click="base.audio_list_delete_at(index)" type="is-danger")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm2AudioTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvForm2AudioTheme
  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0

  .dropdown-item
    padding: 0.75rem

  .media
    justify-content: space-between
    .media-left, .media-right, .media-content
      display: flex
      align-items: center
      justify-content: flex-start
    .media-content
      line-height: 2.0
</style>
