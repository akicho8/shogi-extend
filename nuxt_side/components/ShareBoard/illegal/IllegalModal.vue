<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{reason}}で{{current_location.name}}の勝ち
  .modal-card-body
    template(v-if="SB.auto_resign_info.key === 'is_auto_resign_on'")
      p 終局です
    template(v-else)
      p ルールを守りましょう
      p 対戦相手がお情けで許可してくれた場合は「1手戻す」で指し直して対局を続行できます
      p 反則を受け入れる場合は左上から投了しましょう
  .modal-card-foot
    b-button.close_handle(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "IllegalModal",
  mixins: [support_child],
  props: {
    illegal_names: { type: Array,  required: true, },
  },
  data() {
    return {
      current_location: null, // モーダル発動時の先後
    }
  },
  created() {
    this.current_location = this.SB.current_location
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.SB.illegal_modal_close()
      this.$emit("close")
    },
  },
  computed: {
    reason() {
      return this.illegal_names.join("と")
    },
  },
}
</script>

<style lang="sass">
.IllegalModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
