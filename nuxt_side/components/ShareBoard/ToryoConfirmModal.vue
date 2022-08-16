<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 本当に投了しますか？
  .modal-card-body
    .content
      | リレー将棋の場合はなるべく最後まで指そう
      //- | 投了するとついでに時計と順番を解除します
      //- template(v-if="base.self_is_member_p")
      //-   template(v-if="base.current_turn_self_p")
      //-     | 本当に投了しますか？
      //-   template(v-else)
      //-     | 手番ではないのに投了しますか？
      //- template(v-else)
      //-   | 対局者ではないのに投了しますか？
      //- ol
      //-   li 「負けました」発言する
      //-   li 時計を止める
      //-   li 順番設定を解除する
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 逆転の一手を放つ
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
      font-weight: bold
      &.preset_dropdown_button
        min-width: unset        // プリセット選択は常に目立たないようにする

  .field:not(:last-child)
    margin-bottom: 0.75rem

  .active_bar
    margin-top: 1rem
    height: 6px
    width: 100%
    border-radius: 4px
    &.is_active
      background-color: $primary
      &.is_pause_off
        animation: clock_box_modal_bar_blink 0.5s ease-in-out 0s infinite alternate
        @keyframes clock_box_modal_bar_blink
          0%
            opacity: 1.0
          100%
            opacity: 0.0

  .forms_block
    .cc_form_block:not(:first-child)
      .location_mark
        margin-top: 1.5rem

    +tablet
      .cc_form_block
        .field
          align-items: center
          .field-label.is-small
            padding-top: 0
            margin-right: 1rem
            .label
              white-space: nowrap
              width: 6rem
</style>
