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

  .title.is-3.has-text-centered 詰将棋ファイター
  .buttons.is-centered
    b-button.has-text-weight-bold(@click="$parent.start_handle" type="is-primary") START

  //- b-dropdown.dropdown_menu(position="is-bottom-left")
  //-   b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
  //-   b-dropdown-item(@click="$parent.builder_handle") 問題投稿
  //-   //- b-dropdown-item(separator)
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

  .title
    margin-top: 4rem
  .buttons
    margin-top: 2rem

  // position: relative
  // .dropdown_menu, .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1
</style>
