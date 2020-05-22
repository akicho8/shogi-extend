<template lang="pug">
.the_lobby
  .primary_header
    .user_info_block.is-flex
      .image
        img.is-rounded(:src="app.current_user.avatar_path")
      .name_with_rating
        .name.has-text-weight-bold.is-size-6
          | {{app.current_user.name}}
        .rating.has-text-weight-bold.is-size-7
          | {{app.current_user.rating}}

  .opening(v-if="app.sub_mode === 'opening'")
    .title.is-3.has-text-centered 詰将棋ファイター
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="app.start_handle" type="is-primary") START

  .battle_select(v-if="app.sub_mode === 'battle_select'")
    .title.is-3.has-text-centered モード
    .mode_buttons.buttons.is-centered
      b-button.has-text-weight-bold(@click="app.start_handle2('game_key1')" type="is-primary") マラソン
      b-button.has-text-weight-bold(@click="app.start_handle2('game_key2')" type="is-primary") シングルトン
    .back_button.has-text-centered
      button.delete.is-large.back_button(@click="cancel_handle")
</template>

<script>
import support from "./support.js"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  props: {
    info: { required: true },
  },
  data() {
    return {
    }
  },

  created() {
  },

  beforeDestroy() {
  },

  watch: {
  },

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

  .battle_select
    .title
      margin-top: 4rem
    .mode_buttons
      margin-top: 2rem
      flex-direction: column

    .back_button
      margin-top: 1.5rem

  // position: relative
  // .dropdown_menu, .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1
</style>
