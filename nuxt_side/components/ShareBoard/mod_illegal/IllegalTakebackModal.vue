<template lang="pug">
.modal-card(v-if="SB.illegal_params")
  .modal-card-head
    .modal-card-title
      | {{SB.latest_illegal_name}}
  .modal-card-body
    CustomShogiPlayer.CustomShogiPlayerInsideModal(
      sp_mode="view"
      :sp_body="SB.illegal_params.sfen"
      :sp_turn="SB.illegal_params.turn"
      :sp_mobile_vertical="false"
      :sp_view_mode_piece_movable="false"
      :sp_viewpoint="SB.viewpoint"
      sp_layout="horizontal"
    )

    .resign_message
      p 本来であれば{{SB.user_call_name(SB.latest_illegal_user_name)}}の反則負けです
      p 潔く投了しますか？

    .box.is-shadowless.has-background-light.is-size-7(v-if="SB.illegal_user_info.modal_body_message" v-text="SB.illegal_user_info.modal_body_message(SB)")

    //- template(v-if="SB.debug_mode_p")
    //-   .box.is-shadowless.has-background-light(v-for="e in SB.IllegalUserInfo.values" v-if="e.modal_body_message")
    //-     | {{e.modal_body_message(SB)}}

    .panel(v-if="SB.debug_mode_p && false")
      .panel-heading variables
      .panel-block latest_illegal_name:{{SB.latest_illegal_name}}
      .panel-block latest_illegal_location.key:{{SB.latest_illegal_location.key}}
      .panel-block latest_illegal_it_is_my_team:{{SB.latest_illegal_it_is_my_team}}
      .panel-block latest_illegal_it_is_op_team:{{SB.latest_illegal_it_is_op_team}}
      .panel-block latest_illegal_i_am_trigger:{{SB.latest_illegal_i_am_trigger}}
      .panel-block latest_illegal_user_name:{{SB.latest_illegal_user_name}}
      //- .panel-block latest_illegal_common_message:{{SB.latest_illegal_common_message}}

  .modal-card-foot
    // ここはやっぱり当事者だけのボタンにする
    //- b-button.illegal_takeback_modal_submit_handle_resign(v-if="SB.latest_illegal_resign_button_show_p" @click="SB.illegal_takeback_modal_submit_handle('do_resign')" type="is-danger") 投了する
    //- b-button.illegal_takeback_modal_submit_handle_takeback(@click="SB.illegal_takeback_modal_submit_handle('do_takeback')") {{SB.illegal_takeback_modal_block_button_label}}
    b-button.illegal_takeback_modal_submit_handle_takeback(@click="SB.illegal_takeback_modal_submit_handle('do_takeback')") 待ったする
    b-button.illegal_takeback_modal_submit_handle_resign(@click="SB.illegal_takeback_modal_submit_handle('do_resign')" type="is-danger") 投了する
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "IllegalTakebackModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.IllegalTakebackModal
  // +modal_max_width(512px)
  .modal-card-body
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
    gap: 1rem
    // .CustomShogiPlayer
    //   +foobarbaz
    // max-width: 28rem
    // +mobile
    //   max-width: 18rem
    // .modal-card-foot
    //   flex-direction: row-reverse
    .resign_message
      display: flex
      align-items: center
      flex-direction: column
      gap: 0.25rem
</style>
