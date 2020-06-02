<template lang="pug">
.the_lobby
  .primary_header
    .user_info_block.is-flex
      .image.is_clickable(@click="app.profile_edit_handle")
        img.is-rounded(:src="app.current_user.avatar_path")
      .name_with_rating.is_clickable(@click="app.ov_user_info_set(app.current_user.id)")
        .name.has-text-weight-bold.is-size-6
          | {{app.current_user.name}}
        .rating.has-text-weight-bold.is-size-7
          | {{app.current_user.rating}}

  debug_print(:vars="['app.sub_mode', 'app.members_hash', 'app.question_index', 'app.x_mode', 'app.answer_button_disable_p']" oneline)

  .opening(v-if="app.sub_mode === 'opening'")
    .title.is-3.has-text-centered 将棋トレーニングバトル
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="app.rule_key_select_handle" type="is-primary") START

  .rule_key_select(v-if="app.sub_mode === 'rule_key_select'")
    .title.is-3.has-text-centered モード
    .buttons.is-centered.mode_buttons
      template(v-for="row in app.RuleInfo.values")
        b-button.has-text-weight-bold(@click="app.rule_key_set_handle(row.key)" :type="{'is-primary': app.matching_list_hash[row.key].length >= 1}")
          | {{row.name}}
          | ({{app.matching_list_hash[row.key].length}})
    .back_button.has-text-centered
      button.delete.is-large.back_button(@click="cancel_handle")

  .box.is_debug(v-if="development_p")
    .buttons.is-centered.are-small
      template(v-for="row in app.RuleInfo.values")
        b-button(@click="app.debug_matching_add_handle(row.key)") 自分以外を参加({{row.name}})
      b-button(@click="app.matching_delete_all_handle") 解散
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.app.sub_mode = "opening"
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
      // border: 1px solid blue

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
        .rating

  .opening
    .title
      margin-top: 4rem
    .buttons
      margin-top: 2rem

  .rule_key_select
    .title
      margin-top: 4rem
    .mode_buttons
      margin-top: 2rem
      flex-direction: column
      .button
        min-width: 12rem

    .back_button
      margin-top: 1.5rem

  // position: relative
  // .dropdown_menu, .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1
</style>
