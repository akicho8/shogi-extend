<template lang="pug">
<div class="modal-card the_image_view_point_setting_modal">
  <header class="modal-card-head">
    <p class="modal-card-title">Twitter画像の視点</p>
  </header>
  <section class="modal-card-body">
    <div class="field"><b-radio v-model="new_image_view_point" native-value="self">自分<span class="desc">1手指し継いだとき、その人の視点 (リレー将棋向け・初期値)</span></b-radio></div>
    <div class="field"><b-radio v-model="new_image_view_point" native-value="opponent">相手<span class="desc">1手指し継いだとき、次に指す人の視点 (リレー将棋 or 詰将棋向け)</span></b-radio></div>
    <div class="field"><b-radio v-model="new_image_view_point" native-value="black">先手<span class="desc">常に☗ (詰将棋向け)</span></b-radio></div>
    <div class="field"><b-radio v-model="new_image_view_point" native-value="white">後手<span class="desc">常に☖ (詰将棋を攻められ視点にしたいとき)</span></b-radio></div>
    <div class="has-text-centered"><img :src="twitter_card_preview_url" /></div>
    <div v-if="development_p" class="is_line_break_on" :key="twitter_card_preview_url">{{twitter_card_preview_url}}</div>
  </section>
  <footer class="modal-card-foot">
    <b-button @click="$emit('close')">キャンセル</b-button>
    <b-button @click="submit_handle" class="submit_handle" type="is-primary" :disabled="!change_p">保存</b-button>
  </footer>
</div>
</template>

<script>
export default {
  name: "the_image_view_point_setting_modal",
  data() {
    return {
    }
  },
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
