<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{SB.latest_illegal_name}}
  .modal-card-body
    CustomShogiPlayer(
      sp_mode="view"
      :sp_body="SB.illegal_params.sfen"
      :sp_turn="SB.illegal_params.turn"
      :sp_mobile_vertical="false"
      :sp_view_mode_piece_movable="false"
      :sp_viewpoint="SB.viewpoint"
      sp_layout="horizontal"
    )

    .resign_message(v-if="SB.latest_illegal_common_message" v-text="SB.latest_illegal_common_message")
    .resign_message(v-if="SB.latest_illegal_individual_message" v-text="SB.latest_illegal_individual_message")

    .panel(v-if="SB.debug_mode_p")
      .panel-heading variables
      .panel-block latest_illegal_name:{{SB.latest_illegal_name}}
      .panel-block latest_illegal_location.key:{{SB.latest_illegal_location.key}}
      .panel-block latest_illegal_it_is_my_team:{{SB.latest_illegal_it_is_my_team}}
      .panel-block latest_illegal_it_is_op_team:{{SB.latest_illegal_it_is_op_team}}
      .panel-block latest_illegal_i_am_trigger:{{SB.latest_illegal_i_am_trigger}}
      .panel-block latest_illegal_user_name:{{SB.latest_illegal_user_name}}
      .panel-block latest_illegal_common_message:{{SB.latest_illegal_common_message}}

  .modal-card-foot
    b-button.illegal_block_modal_submit_handle_no(@click="SB.illegal_block_modal_submit_handle('no')") なかったことにする
    b-button.illegal_block_modal_submit_handle_yes(@click="SB.illegal_block_modal_submit_handle('yes')" type="is-danger") 投了する
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "IllegalBlockModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.IllegalBlockModal
  +modal_max_width(640px)
  .modal-card-body
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
    gap: 1rem
    .CustomShogiPlayer
      width: 400px
</style>
