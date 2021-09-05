<template lang="pug">
.XmovieForm2AudioTheme.one_block
  b-field(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message")
    .control
      b-dropdown(v-model="base.audio_theme_key" @active-change="base.active_change_handle")
        template(#trigger)
          b-button(:label="base.audio_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.AudioThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            b-dropdown-item(:value="e.key" @click="sound_play('click')")
              .media
                .media-left
                  b-button(v-if="!e.sample_m4a" rounded icon-left="blank" size="is-small" type="is-ghost")
                  XmovieAudioPlay(:base="base" :src="e.sample_m4a" v-if="e.sample_m4a" @play="e => base.current_play_instance = e")
                .media-content
                  | {{e.name}}

  //- b-field(v-if="base.audio_theme_info.key === 'audio_theme_user'")
  XmovieAudioUpload(:base="base" label="序盤" :file_info.sync="base.au_file1")
  XmovieAudioUpload(:base="base" label="中盤" :file_info.sync="base.au_file2")

  //- b-field(v-if="base.audio_theme_info.key === 'audio_theme_user'")
  //-   b-upload(v-model="base.xaudio_list_for_v_model" multiple drag-drop @input="base.xaudio_file_upload_handle" native accept="audio/*")
  //-     .is-flex.is-align-items-center.px-3.py-1
  //-       b-icon(icon="upload" size="is-small")
  //-       .is-size-7.ml-2 BGMのアップロード
  //-
  //- .box(v-if="base.xaudio_list.length >= 1")
  //-   .media.is-justify-content-space-between(v-for="(file, index) in base.xaudio_list" :key="index")
  //-     .media-left
  //-       XmovieAudioPlay(:base="base" :src="file.url" @play="e => base.current_play_instance = e" v-if="file.url")
  //-     .media-content
  //-       | {{file.attributes.name}}
  //-     .media-right
  //-       button.delete(size="is-small" @click="base.xaudio_list_delete_at(index)" v-if="development_p")
  //-       b-icon.is-clickable(icon="delete" @click.native="base.xaudio_list_delete_at(index)" type="is-danger" size="is-small")
  //-       b-button(icon-left="delete" size="is-small" @click="base.xaudio_list_delete_at(index)" type="is-danger" v-if="development_p")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieForm2AudioTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieForm2AudioTheme
</style>
