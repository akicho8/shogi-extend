<template lang="pug">
.the_lobby
  the_footer
  .primary_header
    //////////////////////////////////////////////////////////////////////////////// ユーザー情報
    .header_item.ljust.user_info_block.is-flex.is_clickable(v-if="app.current_user" @click="app.ov_user_info_set(app.current_user.id)")
      figure.image.avatar_image.ml-2
        img.is-rounded(:src="app.current_user.avatar_path")
      .name_with_rating.ml-2
        span.name.has-text-weight-bold.is-size-6
          | {{app.current_user.name}}
        span.skill_key.has-text-weight-bold.is-size-6.ml-1
          | {{app.current_user.skill_key}}
        span.rating.has-text-weight-bold.is-size-6.ml-1(v-if="app.config.rating_display_p || development_p")
          | {{rating_format(app.current_user.rating)}}

    //////////////////////////////////////////////////////////////////////////////// 通知
    b-dropdown.header_item.rjust(position="is-bottom-left" v-if="app.current_user && app.notifications.length >= 1")
      b-tag.mr-3.has-text-weight-bold.is-flex(rounded slot="trigger" @click.native="app.notification_opened_handle")
        | {{app.unopen_count}}
      template(v-for="row in app.notifications")
        b-dropdown-item(@click="app.ov_question_info_set(row.question_message.question.id)")
          span.is_line_break_on
            | {{app.notification_to_s(row)}}
          span.is-size-7.has-text-grey-light.is_line_break_off.ml-1
            | {{diff_time_format(row.question_message.created_at)}}

    ////////////////////////////////////////////////////////////////////////////////

  debug_print(v-if="app.debug_read_p && false" :vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode']" oneline)

  //- router-link(to="/vr_page1") vr_page1
  //- router-link(to="/vr_page2") vr_page2
  //- hr
  //- router-view

  the_lobby_ac_info
  .title.is-5.has-text-centered.mb-1 将棋トレーニングバトル

  .buttons.is-centered.mt-4.is-marginless.are-large.start_buttons
    b-button.has-text-weight-bold(@click="app.start_handle(false)" :type="{'is-primary': app.lobby_clock_mode === 'active'}")
      | 対人戦
      template(v-if="app.config.lobby_clock_restrict_p")
        template(v-for="e in app.config.lobby_clock_restrict_ranges")
          .is-size-7 {{e.beg}} - {{e.end}}
    b-button.has-text-weight-bold(@click="app.start_handle(true)") 練習

  the_lobby_message
  the_lobby_debug
</template>

<script>
import { support } from "./support.js"

import the_lobby_debug   from "./the_lobby_debug.vue"
import the_lobby_ac_info from "./the_lobby_ac_info.vue"
import the_lobby_message from "./the_lobby_message.vue"
import the_footer        from "./the_footer.vue"

export default {
  name: "the_lobby",
  mixins: [
    support,
  ],
  components: {
    the_lobby_debug,
    the_lobby_ac_info,
    the_lobby_message,
    the_footer,
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby
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
      min-height: 6rem
</style>
