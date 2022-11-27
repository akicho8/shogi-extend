<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 部屋のリンクをコピーしますか？
  .modal-card-body
    p
      | 対戦相手に伝えるとスムーズに誘導できます
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") しない
    b-button.apply_button(@click="apply_handle" type="is-primary") コピーする
</template>

<script>
export default {
  name: "RoomCodeCopyModal",
  inject: ["TheSb"],
  mounted() {
    this.$sound.play("notification")
    this.talk("部屋のリンクをコピーしますか？")
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    apply_handle() {
      if (this.TheSb.room_url_copy_handle()) {
        this.$emit("close")
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.RoomCodeCopyModal
  +modal_width(26rem)
</style>
