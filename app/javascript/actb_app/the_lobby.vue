<template lang="pug">
.the_lobby
  the_footer
  .primary_header
    .header_item.ljust.user_info_block.is-flex.is_clickable(v-if="app.current_user" @click="app.ov_user_info_set(app.current_user.id)")
      .image
        img.is-rounded(:src="app.current_user.avatar_path")
      .name_with_rating
        span.name.has-text-weight-bold.is-size-6
          | {{app.current_user.name}}
        span.skill_key.has-text-weight-bold.is-size-6.ml-1
          | {{app.current_user.skill_key}}
        span.rating.has-text-weight-bold.is-size-7.ml-1(v-if="development_p")
          | {{app.current_user.rating}}

  debug_print(v-if="app.debug_read_p && false" :vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode']" oneline)

  //- router-link(to="/vr_page1") vr_page1
  //- router-link(to="/vr_page2") vr_page2
  //- hr
  //- router-view

  the_lobby_ac_info
  .title.is-4.has-text-centered 将棋トレーニングバトル
  .buttons.is-centered.mt-5
    b-button.has-text-weight-bold(@click="app.start_handle(false)" type="is-primary") START
    b-button.mt-3(@click="app.start_handle(true)") 練習

  the_lobby_message
  the_lobby_debug(v-if="true")
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
        margin-left: 0.5rem
        img
          width: 40px
          height: 40px

      .name_with_rating
        margin-left: 0.5rem
        .name
          .skill_key
        .rating

  .title
    margin-top: 4rem
  .buttons
    flex-direction: column
    .button
      min-width: 6rem
</style>
