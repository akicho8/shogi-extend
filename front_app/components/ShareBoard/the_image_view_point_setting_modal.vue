<template lang="pug">
.modal-card.the_image_view_point_setting_modal
  header.modal-card-head
    p.modal-card-title Twitter画像の視点
  section.modal-card-body
    .field
      b-radio(v-model="new_image_view_point" native-value="self")
        | 自分
        span.desc 1手指し継いだとき、その人の視点 (リレー将棋向け・初期値)
    .field
      b-radio(v-model="new_image_view_point" native-value="opponent")
        | 相手
        span.desc 1手指し継いだとき、次に指す人の視点 (リレー将棋 or 詰将棋向け)
    .field
      b-radio(v-model="new_image_view_point" native-value="black")
        | 先手
        span.desc 常に☗ (詰将棋向け)
    .field
      b-radio(v-model="new_image_view_point" native-value="white")
        | 後手
        span.desc 常に☖ (詰将棋を攻められ視点にしたいとき)
    .has-text-centered
      img(:src="twitter_card_preview_url")
    .is_line_break_on.is-size-7(v-if="development_p" :key="twitter_card_preview_url") {{twitter_card_preview_url}}
  footer.modal-card-foot
    b-button(@click="$emit('close')") キャンセル
    b-button.submit_handle(@click="submit_handle" type="is-primary" :disabled="!change_p") 保存
</template>

<script>
export default {
  name: "the_image_view_point_setting_modal",
  props: [
    "image_view_point",
    "permalink_for",
  ],
  data() {
    return {
      new_image_view_point: this.image_view_point,
    }
  },
  methods: {
    submit_handle() {
      this.$emit("update:image_view_point", this.new_image_view_point)
    },
  },
  computed: {
    twitter_card_preview_url() {
      return this.permalink_for({format: "png", image_view_point: this.new_image_view_point, disposition: "inline"})
    },
    change_p() {
      return this.new_image_view_point !== this.image_view_point
    },
  },
}
</script>

<style lang="sass">
.the_image_view_point_setting_modal
  .desc
    color: $grey
    font-size: $size-7
    margin-left: 0.4rem
  img
    border-radius: 1rem
    border: 1px solid $grey-lighter
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
      min-width: 8rem
</style>
