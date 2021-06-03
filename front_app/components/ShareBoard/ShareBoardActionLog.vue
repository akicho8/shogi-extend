<template lang="pug">
.ShareBoardActionLog.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in filtered_action_logs")
      a.is-clickable.is-block.is_line_break_off(:key="action_log_key(e)" @click="action_log_click_handle(e)")
        b-tag.mr-1(type="is-warning" v-if="e.x_retry_count >= 1") 再送{{e.x_retry_count}}
        span {{e.lmi.next_turn_offset}}
        span.ml-1 {{e.lmi.kif_without_from}}
        span.ml-1 {{e.from_user_name}}
        span.ml-1.is-size-7.time_format.has-text-grey-light {{time_format(e)}}
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"
import ActionLogModal from "./ActionLogModal.vue"

export default {
  name: "ShareBoardActionLog",
  mixins: [
    support_child,
  ],
  mounted() {
    if (this.development_p) {
      for (let i = 0; i < 5; i++) {
        this.base.al_add_test()
      }
    }
  },
  methods: {
    action_log_key(e) {
      return [e.performed_at, e.turn_offset, e.from_connection_id].join("-")
    },
    action_log_click_handle(e) {
      this.sound_play("click")

      this.$buefy.modal.open({
        component: ActionLogModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
          action_log: e,
        },
      })
    },
    time_format(v) {
      return dayjs(v.performed_at).format("HH:mm:ss")
    },
  },
  computed: {
    filtered_action_logs() {
      // return _.reverse(this.base.action_logs.slice())
      return this.base.action_logs
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardActionLog.column
  position: relative
  +tablet
    max-width: 8rem
  +desktop
    max-width: 12rem
  +widescreen
    max-width: 16rem
  +mobile
    height: 10rem

  .scroll_block
    @extend %overlay

    overflow-y: auto
    overflow-x: hidden

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    .time_format
      vertical-align: middle
    a
      text-overflow: ellipsis
      padding: 0.2rem 0.5rem
      color: inherit
      &:hover
        background-color: $grey-lighter

.STAGE-development
  .ShareBoardActionLog
</style>
