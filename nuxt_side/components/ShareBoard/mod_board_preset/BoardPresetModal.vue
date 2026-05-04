<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 手合割
    .evaluation_value 評価値 {{SB.board_preset_info.handicap_desc}}
  .modal-card-body

    .description(v-html="SB.board_preset_info.description")

    ////////////////////////////////////////////////////////////////////////////////

    CustomShogiPlayer.ModalInsideCustomShogiPlayer(
      sp_mode="view"
      :sp_body="SB.board_preset_info.sfen"
      :sp_mobile_vertical="false"
      sp_layout="horizontal"
      sp_operation_disabled
    )

    ////////////////////////////////////////////////////////////////////////////////

    b-field.board_preset_arrow_handle
      // [←]
      p.control
        b-button.previous(@click="SB.board_preset_arrow_handle(-1)" icon-left="chevron-left")

      // [選択]
      template(v-if="true")
        // 結局こっちの方がデスクトップでもスマホでも使いやすい
        b-select.board_preset_key(v-model="SB.board_preset_key" @input="sfx_click()")
          option(v-for="e in SB.BoardPresetInfo.values" :value="e.key")
            | {{e.name}}
      template(v-else)
        // 問題点
        // 1. dropdown-item が長くなるとスクロールが発生して html の領域が見えてしまう
        // 2. scrollable にすると、ましになるが、今度はモバイルの選択領域が短かくなってしまう
        // といった感じで、めちゃくちゃややこしくなる
        p.control
          //- https://buefy.org/documentation/dropdown
          b-dropdown.board_preset_dropdown(
            append-to-body
            position="is-bottom-right"
            v-model="SB.board_preset_key"
            @active-change="e => e && sfx_click()"
            @change="SB.board_preset_change_handle"
            )
            template(#trigger)
              b-button(icon-right="menu-down")
                | {{SB.board_preset_info.name}}
            template(v-for="e in SB.BoardPresetInfo.values")
              b-dropdown-item(:key="e.key" :class="e.key" :value="e.key" v-text="e.name")

      // [→]
      p.control
        b-button.next(@click="SB.board_preset_arrow_handle(1)" icon-left="chevron-right")

    ////////////////////////////////////////////////////////////////////////////////

  .modal-card-foot
    b-button.board_preset_modal_close_handle.has-text-weight-normal(@click="SB.board_preset_modal_close_handle" icon-left="chevron-left")
    b-button.board_preset_apply_handle(@click="SB.board_preset_apply_handle" type="is-primary") 適用
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "BoardPresetModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.BoardPresetModal
  .modal-card-body
    padding: 1.25rem
    gap: 1.0rem

    display: flex
    align-items: center
    justify-content: center
    flex-direction: column

  .field
    margin-block: 0

  .board_preset_dropdown
    .button
      min-width: 10rem

.STAGE-development
  .BoardPresetModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
