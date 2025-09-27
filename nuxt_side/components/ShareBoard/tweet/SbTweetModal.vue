<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title ツイート
    SbColorThemeDropdown

  .modal-card-body
    .preview_image_container.is-flex
      .preview_image.is-flex
        .is-size-7.has-text-grey.has-text-centered(v-if="false")
          | 意図した視点でない場合は<b>ツイート画像の視点設定</b>で変更できます
        b-image(:src="ogp_image_url" @load="SB.color_theme_image_load_handle" @error="SB.color_theme_image_error_handle" :loading="true")
  .modal-card-foot
    b-button.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button(@click="submit_handle" :type="SB.advanced_p ? 'is-twitter' : ''" icon-left="twitter") この局面をツイート
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbTweetModal",
  mixins: [support_child],
  beforeMount() {
    this.SB.color_theme_loading_start() // b-image で初回のロードに時間がかかるため
  },
  methods: {
    close_handle() {
      this.sfx_play_click()
      this.$emit("close")
    },
    submit_handle() {
      this.$emit("close")
      this.SB.tweet_handle()
    },
    preview_url(options = {}) {
      return this.SB.url_merge({
        format: "png",
        viewpoint: this.SB.viewpoint,
        disposition: "inline",
        ...options,
      })
    },
  },
  computed: {
    ogp_image_url() {
      return this.preview_url({
        title: "ogp_image",
      })
    },
  },
}
</script>

<style lang="sass">
.SbTweetModal
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
