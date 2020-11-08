<template lang="pug">
.message_row.is-flex(v-if="show_p")
  .image.is-clickable.is-16x16.avatar_image
    img.is-rounded(:src="message.user.avatar_path" @click="base.ov_user_info_set(message.user.id)")
  .user_name.has-text-grey.is-size-7.is-clickable.has-text-weight-bold(@click="base.ov_user_info_set(message.user.id)")
    | {{message.user.name}}
  .message_body.is-size-7.is_line_break_on
    span(v-html="message_decorate(message_body)" :class="{'has-text-primary': system_message_p, 'has-text-danger': debug_message_p}")
    span.diff_time_format.is-size-11.has-text-grey-light.ml-1.is_line_break_off
      | {{diff_time_format(message.created_at)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "message_row",
  props: {
    message: { type: Object, required: true, },
  },
  mixins: [
    support_child,
  ],
  computed: {
    // デバッグ用のメッセージはデバッグモードのアカウントのときだけ見れる
    show_p() {
      // if (this.debug_message_p && !this.base.debug_read_p) {
      //   return false
      // }
      if (this.base.current_user && this.base.current_user.mute_user_ids.includes(this.message.user.id)) {
        return false
      }

      return true
    },

    system_message_p() {
      return this.mark_level === 1
    },

    debug_message_p() {
      return this.mark_level >= 2
    },

    message_body() {
      let s = this.message.body
      if (this.mark_level >= 1) {
        s = s.replace(this.system_regexp, "")
      }
      return s
    },

    // private
    mark_level() {
      const ms = this.message.body.match(this.system_regexp) || ""
      if (ms) {
        return ms[0].length
      }
    },
    system_regexp() {
      return new RegExp("^\\*+")
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.message_row
  margin-top: 0.2rem
  align-items: flex-start

  .user_name
    white-space: nowrap
    margin-left: 0.5rem
  .message_body
    margin-left: 0.3rem
</style>
