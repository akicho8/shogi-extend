<template lang="pug">
b-field.main_field.XconvForm2AudioTheme(:label="base.AudioThemeInfo.field_label" :message="base.AudioThemeInfo.fetch(base.audio_theme_key).message || base.AudioThemeInfo.field_message")
  .control
    b-dropdown(v-model="base.audio_theme_key" @active-change="active_change_handle")
      template(#trigger)
        b-button(:label="base.audio_theme_info.name" icon-right="menu-down")
      template(v-for="e in base.AudioThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          b-dropdown-item(:value="e.key" @click="sound_play('click')")
            .media
              //- .media-left
              //-   //-   | {{e.name}}
              .media-content
                //- .has-text-weight-bold {{e.name}}
                //- h3 {{e.title}}
                //- span {{e.message}}
                | {{e.name}}
                audio(:src="e.sample_m4a" controls @playing="exclusive_play_handle" :id="e.key")
                XconvAudioPlay(:src="e.sample_m4a" size="is-small" v-if="e.sample_m4a")

                //- audio(:src="require('../../../../bioshogi/lib/bioshogi/assets/audios/breakbeat_long.m4a')" controls)
                //- small.is_line_break_on {{e.message}}{{e.message}}{{e.message}}{{e.message}}
                //- small {{e.message}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm2AudioTheme",
  mixins: [support_child],
  methods: {
    // 対象
    // video も含めたらレビューのところも止まる
    media_elements() {
      // return document.querySelector(".XconvApp").querySelectorAll("audio, video")
      return document.querySelector(".XconvApp").querySelectorAll("audio")
    },

    // 自分以外を停止する
    exclusive_play_handle(current) {
      this.media_elements().forEach(e => {
        if (e.id !== current.target.id) {
          e.pause()
        }
      })
    },

    // ドロップダウンを開閉するタイミング
    active_change_handle(e) {
      // 音を止めて最初に戻す
      this.media_elements().forEach(e => {
        e.pause()
        e.currentTime = 0
      })
      // 開いたときだけクリック音
      if (e) {
        this.sound_play('click')
      }
    },
  },
}
</script>

<style lang="sass">
.XconvForm2AudioTheme
  .dropdown-item
    padding: 1.0rem
    // .media-left
    //   white-space: normal
    //   word-break: break-all
    //   flex: 0 0 30%
    .media-content
      // flex: 0 0 70%
      // line-height: 1.5
    audio
      // width: 100px
      margin: auto
      margin-top: 0.75rem
      // height: 2rem // 調整できるけど Chrome 以外でおかしくなりそう
      display: block
</style>
