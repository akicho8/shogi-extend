<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title ツイート
  .modal-card-body
    .preview_image_container.is-flex
      .preview_image.is-flex
        .is-size-7.has-text-grey.has-text-centered(v-if="false")
          | 意図した視点でない場合は<b>ツイート画像の視点設定</b>で変更できます
        b-image(:src="ogp_image_url")
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
      return this.preview_url({title: "ogp_image", __board_viewpoint_as_image_viewpoint__: false})
    },
  },
}
</script>

<style lang="sass">
.TweetModal
  +modal_max_width(768px)
  .preview_image_container
    justify-content: center
    .preview_image
      flex-direction: column
      align-items: center
      justify-content: center
</style>

