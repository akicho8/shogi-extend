<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 投了
    a.cc_timeout_trigger(@click="SB.cc_timeout_trigger" v-if="SB.debug_mode_p") 時間切れ
  .modal-card-body
    .content
      p {{message}}
      p.give_up_warn_message.is-size-7.has-text-grey(v-if="SB.my_team_member_is_many_p")
        | {{sub_message}}
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 諦めない
    b-button.give_up_handle(@click="give_up_handle" type="is-danger") 投了する
</template>

<script>
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "GiveUpModal",
  mixins: [support_child],
  mounted() {
    this.SB.sb_talk(this.message)
  },
  methods: {
    give_up_handle() {
      this.sfx_click()
      this.$emit("close")
      if (!this.SB.give_up_button_show_p) {
        this.toast_ng("投了確認モーダルを出している間に投了できる条件が無効になりました")
        return
      }
      this.SB.give_up_direct_run_with_valid()
    },
    close_handle() {
      this.sfx_click()
      this.SB.give_up_modal_close()
    },
  },
  computed: {
    message() {
      let s = null
      if (this.SB.i_am_member_p) {
        if (this.SB.current_turn_self_p) {
          s = "本当に投了しますか？"
        } else {
          s = "手番ではないけど本当に投了しますか？"
        }
      } else {
        s = "対局者ではないけど本当に投了しますか？"
      }
      return s
    },
    sub_message() {
      return "自分本位の投了は仲間から反感を買う恐れがあります"
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.STAGE-development
  .GiveUpModal
    __css_keep__: 0

.GiveUpModal
  +modal_width(24rem)

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    .button
      min-width: 6rem
</style>
