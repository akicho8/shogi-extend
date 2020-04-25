<template lang="pug">
.tactic_show.modal-card.is-shogi-player-modal-card
  .modal-card-body.box
    .has-text-centered
      | {{record.key}}

    shogi_player(
      :run_mode="'view_mode'"
      :debug_mode="false"
      :start_turn="record.hit_turn"
      :kifu_body="record.sfen_body"
      :key_event_capture="true"
      :slider_show="true"
      :sfen_show="false"
      :controller_show="true"
      :theme="'simple'"
      :size="'default'"
      :sound_effect="true"
      :volume="0.5"
      :setting_button_show="false"
      :flip="(record.hit_turn % 2) === 0"
    )
</template>

<script>
export default {
  name: "tactic_show",

  props: {
    record: { required: true },
  },

  mounted() {
    this.$gtag.event("open", {event_category: "戦法盤面"})

    this.talk(this.record.key, {rate: 1.5})
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.tactic_show
</style>
