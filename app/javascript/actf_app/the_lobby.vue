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
    this.main_nav_set(false)
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
  position: relative
  .dropdown_menu, .delete
    position: absolute
    top: 0rem
    right: 0rem
    z-index: 1
</style>
