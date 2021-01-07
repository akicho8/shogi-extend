<template lang="pug">
.ShareBoardActionLog.column
  .abcdef(ref="foobar")
    template(v-for="(e, i) in filtered_action_logs")
      a.is-clickable.is-block.is_line_break_off(:key="i" @click="action_log_click_handle(e)")
        span.mx-1 {{e.turn_offset}}
        span.mx-1 {{e.from_user_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardActionLog",
  mixins: [
    support_child,
  ],
  props: {
  },
  data() {
    return {
    }
  },
  mounted() {
    if (this.development_p) {
      for (let i = 0; i < 100; i++) {
        this.base.al_add_test()
      }
    }
  },
  methods: {
    action_log_click_handle(action_log) {
      this.base.current_sfen = action_log.sfen
      this.base.turn_offset = action_log.turn_offset
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
  max-width: 12rem
  // border: 4px dashed $primary ! important
  // font-size: $size-7

  position: relative


  .abcdef
    @extend %overlay

    overflow-y: scroll
    overflow-x: hidden

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    a
      // border: 4px dashed $primary
      text-overflow: ellipsis
      // height: fit-content(100%)

      padding: 0.2rem 0.5rem
      color: inherit
      // font-weight: bold
      &:hover
        background-color: $grey-lighter

.STAGE-development
  .ShareBoardActionLog
</style>
