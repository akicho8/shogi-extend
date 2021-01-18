<template lang="pug">
.WbookLobby
  WbookFooter(:base="base")
  .primary_header
    //////////////////////////////////////////////////////////////////////////////// ユーザー情報
    .header_item.ljust.user_info_block.is-flex.is-clickable(v-if="base.current_user" @click="base.ov_user_info_set(base.current_user.id)")
      figure.image.avatar_image.ml-2
        img.is-rounded(:src="base.current_user.avatar_path")
      .name_with_rating.ml-2
        span.name.has-text-weight-bold.is-size-6
          | {{base.current_user.name}}
        span.skill_key.has-text-weight-bold.is-size-6.ml-1
          | {{base.current_user.skill_key}}
        span.rating.has-text-weight-bold.is-size-6.ml-1(v-if="base.config.rating_display_p || development_p")
          | {{rating_format(base.current_user.rating)}}

    //////////////////////////////////////////////////////////////////////////////// 通知
    b-dropdown.header_item.rjust(position="is-bottom-left" v-if="base.current_user && base.notifications.length >= 1")
      b-tag.mr-3.has-text-weight-bold.is-flex(rounded slot="trigger" @click.native="base.notification_opened_handle")
        | {{base.unopen_count}}
      template(v-for="row in base.notifications")
        b-dropdown-item(@click="base.ov_question_info_set(row.question_message.question.id)")
          span.is_line_break_on
            | {{base.notification_to_s(row)}}
          span.is-size-7.has-text-grey-light.is_line_break_off.ml-1
            | {{diff_time_format(row.question_message.created_at)}}

    ////////////////////////////////////////////////////////////////////////////////

  DebugPrint(v-if="base.debug_read_p && false" :vars="['base.sub_mode', 'base.member_infos_hash', 'base.question_index', 'base.x_mode']" oneline)
  WbookLobbyAcInfo(:base="base")
  .buttons.is-centered.mt-6.is-marginless.are-large.start_buttons
    b-button.has-text-weight-bold(@click="base.start_handle(false)" type="is-primary")
      | 対人戦
    b-button.has-text-weight-bold(@click="base.start_handle(true)") 練習

  WbookLobbyMessage(:base="base")
  WbookLobbyDebug(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookLobby",
  mixins: [
    support_child,
  ],

}
</script>

<style lang="sass">
@import "support.sass"
.WbookLobby
  padding: $padding_top1 0 $margin_bottom

  .primary_header
    .user_info_block
      justify-content: flex-start
      align-items: center
      color: $white

      .image
        img
          width: 40px
          height: 40px

      .name_with_rating
        .name
          .skill_key
        .rating

  .title
    margin-top: 2rem
  .start_buttons
    .button
      min-width: 10rem
</style>
