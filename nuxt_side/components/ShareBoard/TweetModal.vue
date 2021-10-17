<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title ツイート

    b-dropdown(v-model="base.color_theme_key" @active-change="e => e && sound_play('click')" position="is-bottom-left" :max-height="screen_is_desktop ? '50vh' : null" :scrollable="screen_is_desktop" @change="base.color_theme_key_change_handle")
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
        .is-size-7.has-text-grey.has-text-centered(v-if="false")
          | 意図した視点でない場合は<b>ツイート画像の視点設定</b>で変更できます
        b-image(:src="ogp_image_url" @load="base.color_theme_image_load_handle" @error="base.color_theme_image_error_handle" :loading="true")
  .modal-card-foot
    b-button(@click="close_handle") キャンセル
    //- b-button.submit_handle(@click="submit_handle" type="is-primary") 保存
    b-button(@click="submit_handle" :type="base.advanced_p ? 'is-twitter' : ''" icon-left="twitter") この局面をツイート
    //- TweetButton(size="" :body="base.tweet_body" :type="base.advanced_p ? 'is-twitter' : ''" v-if="base.play_mode_p") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TweetModal",
  mixins: [support_child],
  data() {
    return {
      screen_is_desktop: null,
    }
  },
  beforeMount() {
    this.screen_is_desktop = this.screen_match_p("desktop")
  },

  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.$emit("close")
      this.base.tweet_handle()
    },
    preview_url(options = {}) {
      return this.base.permalink_for({
        format: "png",
        abstract_viewpoint: this.base.abstract_viewpoint,
        disposition: "inline",
        ...options,
      })
    },
  },
  computed: {
    ogp_image_url() {
      return this.preview_url({
        title: "ogp_image",
        __board_viewpoint_as_image_viewpoint__: false,
      })
    },
  },
}
</script>

<style lang="sass">
.TweetModal
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
