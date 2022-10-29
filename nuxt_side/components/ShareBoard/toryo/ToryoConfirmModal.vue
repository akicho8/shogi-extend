<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 投了
  .modal-card-body {{message}}
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 考え直す
    b-button.toryo_handle(@click="toryo_handle" type="is-danger") 本当に投了する
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ToryoConfirmModal",
  mixins: [support_child],
  inject: ["TheSb"],
  mounted() {
    this.talk(this.message)
  },
  methods: {
    toryo_handle() {
      this.$sound.play_click()
      this.$emit("close")
      if (!this.TheSb.toryo_button_show_p) {
        this.toast_ng("投了確認モーダルを出している間に投了できる条件が無効になりました")
        return
      }
      this.TheSb.toryo_run_from_modal()
    },
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
  computed: {
    message() {
      let s = null
      if (this.TheSb.self_is_member_p) {
        if (this.TheSb.current_turn_self_p) {
          s = "本当に投了しますか？"
        } else {
          s = "手番ではないけど本当に投了しますか？"
        }
      } else {
        s = "対局者ではないけど本当に投了しますか？"
      }
      return s
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.STAGE-development
  .ToryoConfirmModal

.ToryoConfirmModal
  +modal_width(30rem)

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    .button
      min-width: 6rem
</style>
