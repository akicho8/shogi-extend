<template lang="pug">
.modal-card.AutoMatchingModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 自動マッチング

  section.modal-card-body
    | OK

  footer.modal-card-foot
    b-button.close_button(@click="close_handle") 閉じる
    b-button.close_button(@click="test_handle" v-if="development_p") テスト
    b-button.close_button(@click="clear_handle") クリア
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "AutoMatchingModal",
  mixins: [support_child],
  mounted() {
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
    },
    clear_handle() {
      this.sound_play("click")
    },
  },
}
</script>

<style lang="sass">
.AutoMatchingModal
  height: 80vh
  +tablet
    width: 50rem
  .modal-card-body
    // padding: 0rem
    // background-color: $black-bis
    // .b-table
    //   background-color: $black-bis
  .modal-card-foot
    justify-content: space-between
    .button
      font-weight: bold
      min-width: 8rem
</style>
