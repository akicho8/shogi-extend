<template lang="pug">
.the_lobby.columns
  .column
    .title.is-3.has-text-centered 詰将棋ファイター
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="$parent.start_handle" type="is-primary") START
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="$parent.goto_edit_mode_handle") 投稿
</template>

<script>
import the_support from './the_support'

export default {
  name: "the_editor",
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
</style>
