<template lang="pug">
.modal-card.TrackLogModal
  .modal-card-head
    .modal-card-title
      | ログ ({{base.track_logs.length}})

  .modal-card-body
    ShareBoardTrackLog(:base="base" ref="ShareBoardTrackLog")

  .modal-card-foot
    b-button.close_button(@click="close_handle") 閉じる
    b-button.close_button(@click="test_handle" v-if="development_p") テスト
    b-button.close_button(@click="clear_handle") クリア
</template>

<script>
import _ from "lodash"
import { support_child } from "./support_child.js"

export default {
  name: "TrackLogModal",
  mixins: [support_child],
  mounted() {
    this.base.tl_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.tl_test()
    },
    clear_handle() {
      this.sound_play("click")
      this.base.tl_clear()
    },
  },
}
</script>

<style lang="sass">
.TrackLogModal
  +modal_width(50rem)
  +modal_height(80vh)
  .modal-card-body
    padding: 0rem
</style>
