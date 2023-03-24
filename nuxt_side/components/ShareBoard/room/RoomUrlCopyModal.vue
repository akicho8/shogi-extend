<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 部屋のリンクをコピーしますか？
  .modal-card-body
    p
      | 対戦相手に伝えるとスムーズに誘導できます
    p
      | そのあとは<b>順番設定</b>と<b>対局時計</b>で対戦開始です
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") しない
    b-button.apply_button(@click="apply_handle" type="is-primary") コピーする
</template>

<script>
export default {
  name: "RoomUrlCopyModal",
  inject: ["TheSb"],
  mounted() {
    this.$sound.play("notification")
    this.talk2("部屋のリンクをコピーしますか？")
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
.RoomUrlCopyModal
  +modal_width(26rem)
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 0.5rem
</style>
