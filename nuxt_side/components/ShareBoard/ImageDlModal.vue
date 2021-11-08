<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 画像ダウンロード
    ShareBoardColorThemeDropdown(:base="base")

    b-dropdown(v-model="base.image_size_key" @active-change="e => e && sound_play_click()" position="is-bottom-left" :max-height="screen_is_desktop ? '50vh' : null" :scrollable="screen_is_desktop" @change="base.image_size_key_change_handle")
      template(#trigger)
        b-button(:label="base.image_size_info.name" icon-right="menu-down" size="is-small")
      template(v-for="e in base.ImageSizeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="e.separator")
            b-dropdown-item(separator)
          template(v-else)
            b-dropdown-item(:value="e.key" @click="base.image_size_item_click_handle(e)") {{e.option_name}}

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
  name: "ImageDlModal",
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
      this.base.image_dl_run()
    },
  },
  computed: {
    preview_url() { return this.base.image_dl_preview_url() },
  },
}
</script>

<style lang="sass">
.ImageDlModal
  +modal_max_width(960px)

  .preview_image_container
    justify-content: center
    .preview_image
      flex-direction: column
      align-items: center
      justify-content: center
</style>
