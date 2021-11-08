<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 画像ダウンロード

    b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play_click()" position="is-bottom-left" :max-height="screen_is_desktop ? '50vh' : null" :scrollable="screen_is_desktop" @change="base.color_theme_key_change_handle")
      template(#trigger)
        b-button(:label="base.color_theme_info.name" icon-right="menu-down" size="is-small")
      template(v-for="e in base.ColorThemeInfo.values")
        template(v-if="e.environment == null || e.environment.includes($config.STAGE)")
          template(v-if="e.separator")
            b-dropdown-item(separator)
          template(v-else)
            b-dropdown-item(:value="e.key" @click="base.color_theme_item_click_handle(e)")
              .media
                .media-content
                  .is_line_break_on.is-size-7
                    | {{e.name}}
                  img.is-block(:src="e.thumbnail_url(base)" loading="lazy")

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
      screen_is_desktop: null,
    }
  },
  beforeMount() {
    this.screen_is_desktop = this.screen_match_p("desktop")
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

  // 上下の不自然な隙間を取る
  .dropdown-content
    padding-top: 0
    padding-bottom: 0
    .dropdown-item
      padding: 0.75rem
      +desktop
        min-width: 8rem

  .preview_image_container
    justify-content: center
    .preview_image
      flex-direction: column
      align-items: center
      justify-content: center
</style>
