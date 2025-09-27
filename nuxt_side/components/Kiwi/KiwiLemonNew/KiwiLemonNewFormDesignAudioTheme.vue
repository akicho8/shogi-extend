<template lang="pug">
.KiwiLemonNewFormDesignAudioTheme.field_block
  b-field(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message")
    .control
      b-button(@click="base.audio_select_modal_handle" icon-right="view-comfy") {{base.audio_theme_info.name}}

  b-field(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message" v-if="development_p")
    .control
      b-dropdown(v-model="base.audio_theme_key" @active-change="base.active_change_handle")
        template(#trigger)
          b-button(:label="base.audio_theme_info.name" icon-right="menu-down")
        template(v-for="e in base.AudioThemeInfo.values")
          template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
            template(v-if="e.separator")
              b-dropdown-item(separator)
            template(v-else)
              b-dropdown-item(:value="e.key" @click="sfx_play_click()")
                .media
                  .media-left(v-if="e.sample_source")
                    KiwiLemonNewAudioPlay(:base="base" :src="e.sample_source" :volume="base.main_volume" @play="e => base.current_play_instance = e")
                  .media-content
                    | {{e.name}}
                    .audio_desc(v-if="e.audio_part_a_duration")
                      .audio_desc_item(v-if="e.author_raw") {{e.author_raw}}
                      .audio_desc_item(v-if="e.author") 作曲: {{e.author}}
                      .audio_desc_item
                        span 長さ: {{e.duration_mmss}}
                        span.ml-1(v-if="e.duration_sec >= 60") ({{e.duration_sec}}s)
                      .audio_desc_item(v-if="e.bpm")
                        span 速度: {{e.bpm}}BPM
                      .audio_desc_item(v-if="e.loop_support_p") ループ対応
                    p.is-size-7.is_line_break_on(v-if="e.desc") {{e.desc}}

                  .media-right
                    a(:href="e.source_url" v-if="e.source_url" target="_blank")
                      b-icon(icon="open-in-new" size="is-small")

  KiwiLemonNewAudioUpload(:base="base" label="序盤" :file_info.sync="base.u_audio_file_a")
  KiwiLemonNewAudioUpload(:base="base" label="中盤" :file_info.sync="base.u_audio_file_b")

  //- b-field(v-if="base.audio_theme_info.key === 'is_audio_theme_custom'")
  //-   b-upload(v-model="base.xaudio_list_for_v_model" multiple drag-drop @input="base.xaudio_file_upload_handle" native accept="audio/*")
  //-     .is-flex.is-align-items-center.px-3.py-1
  //-       b-icon(icon="upload" size="is-small")
  //-       .is-size-7.ml-2 BGMのアップロード
  //-
  //- .box(v-if="base.xaudio_list.length >= 1")
  //-   .media.is-justify-content-space-between(v-for="(file, index) in base.xaudio_list" :key="index")
  //-     .media-left
  //-       KiwiLemonNewAudioPlay(:base="base" :src="file.url" @play="e => base.current_play_instance = e" v-if="file.url")
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
  name: "KiwiLemonNewFormDesignAudioTheme",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewFormDesignAudioTheme
  .dropdown-item
    // 選択中でも a の icon が青いままなので白くする
    &.is-active
      a
        color: unset
    // 選択中していないときだけ作者を薄くする
    &:not(.is-active)
      .audio_desc
        font-size: $size-7
        color: $grey
        .audio_desc_item
          __css_keep__: 0

    .media-content
      align-items: center       // 「カスタム」の文字を縦中央へ
</style>
