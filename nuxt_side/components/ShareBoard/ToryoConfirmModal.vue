<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 投了
  .modal-card-body
    | {{message}}
  //- .modal-card-body
  //-   .content
  //-     //- p 投了すると実行する内容
  //-     //- ul
  //-     //-   //- li リレー将棋の場合はなるべく最後まで指そう
  //-     //-   li 投了の旨を発言する
  //-     //-   li 時計を止める
  //-     //-   li 順番を解除する
  //-     //- | 投了するとついでに時計と順番を解除します
  //-     //- template(v-if="base.self_is_member_p")
  //-     //-   template(v-if="base.current_turn_self_p")
  //-     //-     | 本当に投了しますか？
  //-     //-   template(v-else)
  //-     //-     | 手番ではないのに投了しますか？
  //-     //- template(v-else)
  //-     //-   | 対局者ではないのに投了しますか？
  //-     //- ol
  //-     //-   li 「負けました」発言する
  //-     //-   li 時計を止める
  //-     //-   li 順番設定を解除する
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 逆転の一手を放つ
    b-button.toryo_handle(@click="toryo_handle" type="is-danger") 本当に投了する
</template>

<script>
import { support_child } from "./support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ToryoConfirmModal",
  mixins: [
    support_child,
  ],
  mounted() {
    this.talk(this.message)
  },
  methods: {
    toryo_handle() {
      this.sound_play_click()
      this.$emit("close")
      if (!this.base.toryo_button_show_p) {
        this.toast_ng("投了確認モーダルを出している間に投了できる条件が無効になりました")
        return
      }
      this.base.toryo_run_from_modal()
    },
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
  },
  computed: {
    message() {
      let s = null
      if (this.base.self_is_member_p) {
        if (this.base.current_turn_self_p) {
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
@import "support.sass"

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
