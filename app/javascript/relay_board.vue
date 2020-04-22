<template lang="pug">
.relay_board
  .columns
    .column
      shogi_player(
        ref="main_sp"
        :run_mode="'play_mode'"
        :kifu_body="current_position"
        :summary_show="false"
        :slider_show="true"
        :setting_button_show="development_p"
        :size="'large'"
        :sound_effect="true"
        :controller_show="true"
        :human_side_key="'both'"
        :theme="'simple'"
        :vlayout="false"
        @update:play_mode_advanced_full_moves_sfen="play_mode_advanced_full_moves_sfen_set"
      )
</template>

<script>
export default {
  name: "relay_board",
  mixins: [
  ],
  props: {
    info: { required: false },
  },
  data() {
    return {
      current_position: this.$route.query.position,
    }
  },
  created() {
  },
  methods: {
    play_mode_advanced_full_moves_sfen_set(v) {
      this.current_position = v
      window.history.replaceState("", null, this.permalink_url)
    },
  },
  computed: {
    permalink_url() {
      const url = new URL(location)
      url.searchParams.set("position", this.current_position)
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.relay_board
</style>
