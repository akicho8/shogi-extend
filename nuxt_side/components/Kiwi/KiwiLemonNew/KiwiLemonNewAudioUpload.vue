<template lang="pug">
.KiwiLemonNewAudioUpload(v-if="base.audio_theme_info.key === 'is_audio_theme_custom'")
  b-field
    // 次のように accept="audio/*" をつけると iPhone から m4a が選択できなくなるので注意
    //- b-upload(drag-drop @input="upload_handle" native accept="audio/*")
    b-upload(drag-drop @input="upload_handle" native)
      .is-flex.is-align-items-center.px-3.py-1
        b-icon(icon="upload" size="is-small")
        .is-size-7.ml-2 {{label}}

  .audio_preview.mt-2(v-if="new_file_info")
    KiwiLemonNewAudioPlay(:base="base" :src="new_file_info.url" :volume="base.main_volume" @play="e => base.current_play_instance = e")
    .ml-2 {{new_file_info.attributes.name}}
    button.delete.ml-2(size="is-small" @click="delete_handle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewAudioUpload",
  mixins: [support_child],
  props: {
    label: { type: String, required: true },
    file_info: { type: Object },
  },
  data() {
    return {
      new_file_info: this.file_info,
    }
  },

  methods: {
    upload_handle(file) {
      if (file == null) {
        this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると file が null で呼ばれる")
      } else {
        this.sfx_click()
        const reader = new FileReader()
        reader.addEventListener("load", () => {
          this.new_file_info = {
            attributes: {
              name: file.name,
              size: file.size,
              type: file.type,
            },
            url: reader.result,
          }
          this.$emit("update:file_info", this.new_file_info)
          this.toast_primary(`アップロードしました`)
        }, false)
        reader.readAsDataURL(file)
      }
    },

    delete_handle(index) {
      this.sfx_click()
      this.new_file_info = null
      this.$emit("update:file_info", this.new_file_info)
      this.toast_primary("削除しました")
    },
  },
}
</script>

<style lang="sass">
.KiwiLemonNewAudioUpload
  &:not(:first-child)
    margin-top: 1.5rem

  .audio_preview
    display: flex
    align-items: center
</style>
