<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 千日手
  .modal-card-body
    p 連続王手の場合は王手していた側の反則負けです
    p 対局を続行するにはそのまま続けてください
  .modal-card-foot
    b-button(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
export default {
  name: "SntModal",
  inject: ["TheSb"],
  data() {
    return {
      current_location: null, // モーダル発動時の先後
    }
  },
  created() {
    this.current_location = this.TheSb.current_location
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.TheSb.snt_modal_close()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.SntModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
