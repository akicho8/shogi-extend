<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 投了
  .modal-card-body
    .content
      p {{message}}
      p.is-size-7.has-text-grey
        | 早すぎる投了は反感を買う場合があります
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 諦めない
    b-button.give_up_handle(@click="give_up_handle" type="is-danger") 本当に投了する
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "GiveUpConfirmModal",
  mixins: [support_child],
  inject: ["TheSb"],
  mounted() {
    this.talk(this.message)
  },
  methods: {
    give_up_handle() {
      this.$sound.play_click()
      this.$emit("close")
      if (!this.TheSb.give_up_button_show_p) {
        this.toast_ng("投了確認モーダルを出している間に投了できる条件が無効になりました")
        return
      }
      this.TheSb.give_up_run_from_modal()
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
  .GiveUpConfirmModal

.GiveUpConfirmModal
  +modal_width(30rem)

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    .button
      min-width: 6rem
</style>
