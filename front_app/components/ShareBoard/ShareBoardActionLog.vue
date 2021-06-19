<template lang="pug">
.ShareBoardActionLog.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in filtered_action_logs")
      ShareBoardAvatarLine.is-clickable(:info="e" tag="a" :key="action_log_key(e)" @click="action_log_click_handle(e)")
        b-tag.flex_item(type="is-warning" v-if="present_p(e.x_retry_count) && e.x_retry_count >= 1") 再送{{e.x_retry_count}}
        b-tag.flex_item(type="is-primary" v-if="e.label") {{e.label}}
        template(v-if="e.lmi")
          .flex_item {{e.lmi.next_turn_offset}}
          .flex_item {{e.lmi.kif_without_from}}
        .flex_item.is-size-7.time_format.has-text-grey-light(v-if="e.performed_at") {{time_format(e)}}
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"
import ActionLogJumpPreviewModal from "./ActionLogJumpPreviewModal.vue"

export default {
  name: "ShareBoardActionLog",
  mixins: [
    support_child,
  ],
  mounted() {
    if (this.development_p) {
      for (let i = 0; i < 3; i++) {
        this.base.al_add_test()
      }
    }
  },
  methods: {
    action_log_key(e) {
      return [e.performed_at, e.turn_offset, e.from_connection_id || ""].join("-")
    },
    action_log_click_handle(e) {
      this.sound_play("click")

      this.$buefy.modal.open({
        component: ActionLogJumpPreviewModal,
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

    padding: 0

    .time_format
      vertical-align: middle

    .ShareBoardAvatarLine
      line-height: 2.25
      // text-overflow: ellipsis
      // overflow-x: auto
      padding: 0.2rem 0rem
      color: inherit
      &:hover
        background-color: $white-ter

    // a
    //   display: flex
    //   justify-content: start
    //   align-items: center
    // 
    //   text-overflow: ellipsis
    //   padding: 0.2rem 0.5rem
    //   color: inherit
    //   &:hover
    //     background-color: $grey-lighter
    //   > *:not(:first-child)
    //     margin-left: 0.25rem

.STAGE-development
  .ShareBoardActionLog
    .scroll_block
      // border-radius: 3px
      // background-color: $white-ter
</style>
