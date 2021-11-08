<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 画像ダウンロード
    ShareBoardColorThemeDropdown(:base="base")

  .modal-card-body
    .preview_image_container.is-flex
      .preview_image.is-flex
        b-image(:src="preview_url" @load="base.color_theme_image_load_handle" @error="base.color_theme_image_error_handle" :loading="true")
  .modal-card-foot
    b-button.close_handle(@click="close_handle") キャンセル
    b-button.download_handle(@click="download_handle" type="is-primary") ダウンロード
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ImageDownloadModal",
  mixins: [support_child],
  data() {
    return {
    }
  },
  beforeMount() {
    this.base.color_theme_loading_start() // b-image で初回のロードに時間がかかるため
  },
  methods: {
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    download_handle() {
      this.sound_play_click()
      window.location.href = this.main_url({disposition: "attachment"})
      this.base.shared_al_add_simple("画像ダウンロード")
    },
    main_url(options = {}) {
      return this.base.permalink_for({
        format: "png",
        // abstract_viewpoint: this.base.abstract_viewpoint,
        abstract_viewpoint: this.base.sp_viewpoint,
        disposition: "inline",
        ...options,
      })
    },
  },
  computed: {
    preview_url() {
      return this.main_url()
    },
  },
}
</script>

<style lang="sass">
.ImageDownloadModal
  +modal_max_width(960px)

  .preview_image_container
    justify-content: center
    .preview_image
      flex-direction: column
      align-items: center
      justify-content: center
</style>
