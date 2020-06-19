<template lang="pug">
.the_lobby
  ////////////////////////////////////////////////////////////////////////////////
  .start_mode(v-if="app.sub_mode === 'start_mode'")
    the_footer
    .primary_header
      .header_item.ljust.user_info_block.is-flex.is_clickable(v-if="app.current_user" @click="app.ov_user_info_set(app.current_user.id)")
        .image
          img.is-rounded(:src="app.current_user.avatar_path")
        .name_with_rating
          span.name.has-text-weight-bold.is-size-6
            | {{app.current_user.name}}
          span.udemae_key.has-text-weight-bold.is-size-6.ml-1
            | {{app.current_user.udemae_key}}
          span.rating.has-text-weight-bold.is-size-7.ml-1(v-if="development_p")
            | {{app.current_user.rating}}
      .header_center_title(v-if="app.sub_mode === 'rule_select_mode'") ルール選択

    debug_print(v-if="app.debug_mode_p && false" :vars="['app.sub_mode', 'app.member_infos_hash', 'app.question_index', 'app.x_mode', 'app.answer_button_disable_p']" oneline)

    //- router-link(to="/vr_page1") vr_page1
    //- router-link(to="/vr_page2") vr_page2
    //- hr
    //- router-view

    the_lobby_ac_info
    .title.is-4.has-text-centered 将棋トレーニングバトル
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="app.start_handle" type="is-primary") START
    the_lobby_message
    the_lobby_debug(v-if="true")

  ////////////////////////////////////////////////////////////////////////////////
  .rule_select_mode(v-if="app.sub_mode === 'rule_select_mode'")
    .primary_header
      b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="rule_cancel_handle")
      .header_center_title(v-if="app.sub_mode === 'rule_select_mode'") ルール選択

    .buttons.is-centered.rule_buttons
      template(v-for="row in app.RuleInfo.values")
        template(v-if="row.display_p || development_p")
          b-button.has-text-weight-bold(@click="app.rule_key_set_handle(row)" :type="{'is-primary': app.matching_list_hash[row.key].length >= 1}" expanded)
            | {{row.name}}
            template(v-if="app.debug_mode_p")
              | ({{app.matching_list_hash[row.key].length}})

</template>

<script>
import { support } from "./support.js"
import the_lobby_debug   from "./the_lobby_debug.vue"
import the_lobby_ac_info from "./the_lobby_ac_info.vue"
import the_lobby_message from "./the_lobby_message.vue"
import the_footer from "./the_footer.vue"

export default {
  name: "the_builder",
  mixins: [
  support,
  ],
  components: {
    the_lobby_debug,
    the_lobby_ac_info,
    the_footer,
    the_lobby_message,
  },
  methods: {
    rule_cancel_handle() {
      this.sound_play("click")
      this.app.sub_mode = "start_mode"
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby
  @extend %padding_top_for_primary_header

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
          .udemae_key
        .rating

  .start_mode
    .title
      margin-top: 4rem
    .buttons
      margin-top: 1.5rem

  .rule_select_mode
    margin: 1rem 0.7rem $margin_bottom
    .title
      margin-top: 4rem
    .rule_buttons
      margin-top: 0.5rem
      flex-direction: column
      .button
        height: 3.75rem
        &:not(:first-child)
          margin-top: 0.3rem // ボタンとボタンの隙間

    .back_button
      margin-top: 1.5rem

  // position: relative
  // .dropdown_menu, .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1
</style>
