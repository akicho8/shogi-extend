<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 千日手
  .modal-card-body
    p 連続王手の場合は王手していた側の反則負けです
    p 合意の上、このまま対局を続けてもかまいません
  .modal-card-foot
    b-button.close_handle(@click="close_handle" type="is-primary") OK
</template>

<script>
export default {
  name: "PerpetualModal",
  inject: ["TheSb"],
  data() {
    return {
      current_location: null, // モーダル発動時の先後(未使用)
    }
  },
  created() {
    this.current_location = this.TheSb.current_location
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.TheSb.perpetual_modal_close()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.PerpetualModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
