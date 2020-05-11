<template lang="pug">
.the_lobby.columns
  .column
    .title.is-3.has-text-centered 詰将棋ファイター
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="$parent.start_handle" type="is-primary") START

    b-dropdown.dropdown_menu(position="is-bottom-left")
      b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
      b-dropdown-item(@click="$parent.goto_edit_mode_handle") 問題投稿
      //- b-dropdown-item(separator)
</template>

<script>
import the_support from './the_support'

export default {
  name: "the_builder",
  mixins: [
    the_support,
  ],
  props: {
    info: { required: true },
  },
  data() {
    return {
    }
  },

  created() {
    this.main_nav_set(false)
  },

  watch: {
  },

  methods: {
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.the_lobby
  position: relative
  .dropdown_menu, .delete
    position: absolute
    top: 0rem
    right: 0rem
    z-index: 1
</style>
