<template lang="pug">
.message_row.is-flex
  .image.is_clickable
    img.is-rounded(:src="message.user.avatar_path" @click="app.ov_user_info_set(message.user.id)")
  .user_name.has-text-grey.is-size-7.is_clickable(@click="app.ov_user_info_set(message.user.id)")
    | {{message.user.name}}
  .message_body(v-html="message.body")
</template>

<script>
import { support } from "../support.js"

export default {
  name: "message_row",
  props: {
    message: { type: Object, required: true, },
  },
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
$message_row_image_size: 16px
.message_row
  margin-top: 0.1rem
  justify-content: flex-start
  align-items: center
  .image
    img
      height: $message_row_image_size
      width: $message_row_image_size
  .user_name
    white-space: nowrap
    margin-left: 0.5rem
  .message_body
    margin-left: 0.3rem
</style>
