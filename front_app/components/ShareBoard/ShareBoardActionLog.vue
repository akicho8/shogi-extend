<template lang="pug">
.ShareBoardActionLog.column
  .abcdef(ref="foobar")
    template(v-for="(e, i) in reverse_action_logs")
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
    this.base.al_push({turn_offset: 1, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 2, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 3, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 4, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 5, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 6, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 7, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 8, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 9, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 10, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 11, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 12, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 13, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 14, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 15, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 16, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 17, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 18, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 19, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 20, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 30, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 31, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 32, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 33, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 34, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 35, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 36, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 37, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 38, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 39, from_user_name: "あいうえお"})
    this.base.al_push({turn_offset: 40, from_user_name: "あいうえお"})
  },
  methods: {
    action_log_click_handle(action_log) {
      this.sound_play("click")
      this.base.current_sfen = action_log.sfen
      this.base.turn_offset = action_log.turn_offset
    },
  },
  computed: {
    reverse_action_logs() {
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

    border-radius: 8px
    background-color: $white-ter
    padding: 0.5rem 0

    a
      // border: 4px dashed $primary
      text-overflow: ellipsis
      // height: fit-content(100%)

      padding: 0.1rem 0.5rem
      color: inherit
      // font-weight: bold
      &:hover
        background-color: $grey-lighter

.STAGE-development
  .ShareBoardActionLog
</style>
