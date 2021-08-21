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
              .media-left
                | {{e.name}}
              .media-right
                XconvAudioPlay(:src="e.sample_m4a" size="is-small" v-if="e.sample_m4a" @play="e => current_play_instance = e")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm2AudioTheme",
  mixins: [support_child],
  data() {
    return {
      current_play_instance: null, // 最後に再生した Howl のインスタンス
    }
  },

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
      } else {
        if (this.current_play_instance) {
          this.current_play_instance.stop()
          this.current_play_instance = null
        }
      }
    },
  },
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

    .media-left, .media-left
      margin: auto 0            // 縦を中央へ

    // .media-left
    //   //   white-space: normal
    //   //   word-break: break-all
    //   //   flex: 0 0 30%
    //   // flex-basis:
    // .media-right
    //   // flex: 0 0 70%
    //   // line-height: 1.5
    // audio
    //   // width: 100px
    //   margin: auto
    //   margin-top: 0.75rem
    //   // height: 2rem // 調整できるけど Chrome 以外でおかしくなりそう
    //   display: block
</style>
