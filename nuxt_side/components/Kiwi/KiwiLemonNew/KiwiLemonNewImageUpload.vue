<template lang="pug">
.KiwiLemonNewImageUpload
  b-field
    b-upload(drag-drop @input="upload_handle" native accept="image/*")
      .is-flex.is-align-items-center.px-3.py-1
        b-icon(icon="upload" size="is-small")
        .is-size-7.ml-2 {{label}}

  .image_preview.mt-2(v-if="new_file_info")
    img(:src="new_file_info.url")
    button.delete(size="is-small" @click="delete_handle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewImageUpload",
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
.KiwiLemonNewImageUpload
  &:not(:first-child)
    margin-top: 1.5rem

  .image_preview
    height: 8rem
    display: flex
    align-items: center
    img
      max-height: 100%
      max-width:  100%
      border: 1px solid $grey-lighter
      border-radius: 4px
    button
      margin-left: 0.5rem
</style>
