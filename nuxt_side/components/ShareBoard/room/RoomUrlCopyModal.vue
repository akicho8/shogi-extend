<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 部屋のリンクをコピーしますか？
  .modal-card-body
    p 対戦相手に伝えるとこの部屋に飛んでこれます
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.apply_button(@click="apply_handle" type="is-primary") コピーする
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "RoomUrlCopyModal",
  mixins: [support_child],
  mounted() {
    this.sfx_play("se_notification")
    this.SB.sb_talk("部屋のリンクをコピーしますか？")
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    apply_handle() {
      this.SB.room_url_copy_handle()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.RoomUrlCopyModal
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 0.5rem
</style>
