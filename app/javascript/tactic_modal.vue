<template lang="pug">
  b-modal.tactic_modal(:active.sync="new_modal_p" trap-focus animation="zoom-in" :full-screen="false" :can-cancel="['escape', 'outside']" :has-modal-card="true" v-if="record")
    .modal-card.is-shogi-player-modal-card(style="width:auto")
      .modal-card-body.box
        .delete.is-medium(aria-label="close" @click="new_modal_p = false")

        .title.is-5.yumincho.has-text-centered
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
          :theme="'real'"
          :size="'default'"
          :sound_effect="true"
          :volume="0.2"
          :setting_button_show="false"
          ref="sp_modal"
        )
</template>

<script>

export default {
  name: "tactic_modal",

  props: {
    tactic_name: String,
    tactic_modal_p: Boolean,
  },

  data() {
    return {
      new_modal_p: this.tactic_modal_p,
      record: null,
    }
  },

  watch: {
    tactic_modal_p(v) { this.new_modal_p = v                   }, // 外→内 tactic_modal_p --> new_modal_p
    new_modal_p(v)    {                                           // 外←内 tactic_modal_p <-- new_modal_p
      this.$emit("update:tactic_modal_p", v)
      if (v) {
        this.http_get_command(this.get_url, {}, data => {
          this.record = data
        })
      } else {
        this.record = null
      }
    },
    record(v) {
      if (v) {
        this.talk(v.key, {rate: 1.5})
      }
    },
  },

  computed: {
    get_url() {
      return `${this.url_prefix}/tactics/${this.tactic_name}.json`
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.tactic_modal
  // 閉じボタン
  .delete
    position: absolute
    top: 0.6rem
    left: 0.6rem

  // 上下のスペース
  .modal-card-body
    padding-top: 3rem
    padding-bottom: 3rem
</style>
