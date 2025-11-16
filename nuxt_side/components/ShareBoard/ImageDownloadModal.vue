<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 画像ダウンロード
      template(v-if="SB.debug_mode_p")
        | ({{SB.image_download_success_count}})

    SbColorThemeDropdown

    b-dropdown.image_size_key_dropdown(v-model="SB.image_size_key" @active-change="e => e && sfx_click()" position="is-bottom-left" @change="SB.image_size_key_change_handle")
      template(#trigger)
        b-button(:label="SB.image_size_info.name" icon-right="menu-down" size="is-small")
      template(v-for="e in SB.ImageSizeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="e.separator")
            b-dropdown-item(separator)
          template(v-else)
            b-dropdown-item(:class="e.key" :value="e.key" @click="SB.image_size_item_click_handle(e)") {{e.option_name}}

  .modal-card-body
    .preview_image_container.is-flex
      .preview_image.is-flex
        b-image(:src="preview_url" @load="SB.color_theme_image_load_handle" @error="SB.color_theme_image_error_handle" :loading="true")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.download_handle(@click="download_handle" type="is-primary") ダウンロード
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ImageDownloadModal",
  mixins: [support_child],
  beforeMount() {
    this.SB.color_theme_loading_start() // b-image で初回のロードに時間がかかるため
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    download_handle() {
      this.sfx_click()
      this.SB.image_download_run()
    },
  },
  computed: {
    preview_url() { return this.SB.image_download_preview_url() },
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
