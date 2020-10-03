<template lang="pug">
.modal-card.ImageViewPointSettingModal(style="width:auto")
  header.modal-card-head
    p.modal-card-title 視点設定
  section.modal-card-body
    .field.my-1
      b-radio(size="is-small" v-model="new_image_view_point" native-value="self")
        | 1手指し継いだとき、自分の視点 (リレー将棋向け・初期値)
    .field.my-1
      b-radio(size="is-small" v-model="new_image_view_point" native-value="opponent")
        | 1手指し継いだとき、相手の視点 (リレー将棋向け・詰将棋向け)
    .field.my-1
      b-radio(size="is-small" v-model="new_image_view_point" native-value="black")
        | 常に☗ (詰将棋向け)
    .field.my-1
      b-radio(size="is-small" v-model="new_image_view_point" native-value="white")
        | 常に☖ (逃れ将棋向け)
    .preview_image_container.is-flex.mt-3
      .preview_image.is-flex
        .is-size-7.has-text-weight-bold.has-text-grey.has-text-centered
          | Twitter画像の視点
        b-image.mr-1(:src="ogp_image_url")
      .preview_image.is-flex
        .is-size-7.has-text-weight-bold.has-text-grey.has-text-centered
          | ブラウザで開いたときの視点
        b-image.ml-1(:src="opened_image_url")
  footer.modal-card-foot
    b-button(@click="close_handle") キャンセル
    b-button.submit_handle(@click="submit_handle" type="is-primary") 保存
</template>

<script>
export default {
  name: "ImageViewPointSettingModal",
  props: {
    image_view_point: { type: String,   required: true, },
    permalink_for:    { type: Function, required: true, },
  },
  data() {
    return {
      new_image_view_point: this.image_view_point,
    }
  },
  watch: {
    new_image_view_point(v) {
      this.sound_play("click")
    },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
      nthis.$emit("update:image_view_point", this.new_image_view_point)
    },
    preview_url(options = {}) {
      return this.permalink_for({
        format: "png",
        image_view_point: this.new_image_view_point,
        disposition: "inline",
        ...options,
      })
    },
  },
  computed: {
    ogp_image_url() {
      return this.preview_url({title: "ogp_image", __board_flip_as_image_flip__: false})
    },
    opened_image_url() {
      return this.preview_url({title: "opened_image", __board_flip_as_image_flip__: true})
    },
  },
}
</script>

<style lang="sass">
.ImageViewPointSettingModal
  .preview_image_container
    justify-content: center
    .preview_image
      flex-direction: column
      align-items: center
      justify-content: center
      img
        border-radius: 0.4rem
        border: 1px solid $grey-lighter
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
      min-width: 8rem
</style>
