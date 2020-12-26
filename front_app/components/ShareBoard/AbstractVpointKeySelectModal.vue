<template lang="pug">
.modal-card.AbstractVpointKeySelectModal(style="width:auto")
  header.modal-card-head
    p.modal-card-title 視点設定
  section.modal-card-body
    .field.my-1
      b-radio(size="is-small" v-model="new_abstract_vpoint_key" native-value="self")
        | 1手指し継いだとき自分の視点 (リレー将棋向け・初期値)
    .field.my-1
      b-radio(size="is-small" v-model="new_abstract_vpoint_key" native-value="opponent")
        | 1手指し継いだとき相手の視点 (リレー将棋向け)
    .field.my-1
      b-radio(size="is-small" v-model="new_abstract_vpoint_key" native-value="black")
        | 常に☗ (詰将棋向け)
    .field.my-1
      b-radio(size="is-small" v-model="new_abstract_vpoint_key" native-value="white")
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
  name: "AbstractVpointKeySelectModal",
  props: {
    abstract_vpoint_key:  { type: String,   required: true, },
    permalink_for: { type: Function, required: true, },
  },
  data() {
    return {
      new_abstract_vpoint_key: this.abstract_vpoint_key,
    }
  },
  watch: {
    new_abstract_vpoint_key(v) {
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
      this.$emit("update:abstract_vpoint_key", this.new_abstract_vpoint_key)
    },
    preview_url(options = {}) {
      return this.permalink_for({
        format: "png",
        abstract_vpoint_key: this.new_abstract_vpoint_key,
        disposition: "inline",
        ...options,
      })
    },
  },
  computed: {
    ogp_image_url() {
      return this.preview_url({title: "ogp_image", __board_vpoint_as_image_vpoint__: false})
    },
    opened_image_url() {
      return this.preview_url({title: "opened_image", __board_vpoint_as_image_vpoint__: true})
    },
  },
}
</script>

<style lang="sass">
.AbstractVpointKeySelectModal
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
