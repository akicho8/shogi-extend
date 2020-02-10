<template lang="pug">
  span
    slot(name="notify_to_all")
      button.button(@click.prevent="modal_open")
        b-icon(icon="volume-high" size="is-small")
        | &nbsp;
        | 全体通知

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        .modal-card-head
          .modal-card-title
            | 全体通知
        .modal-card-body
          b-field(label="")
            textarea.textarea(v-model.trim="message" @keydown.enter="message_enter_handle" autocomplete="off" ref="message_input")
        footer.modal-card-foot.space_between
          button.button(@click="message_post_button_handle") 送信
</template>

<script>
import message_form_shared from "message_form_shared"

export default {
  mixins: [
    message_form_shared,
  ],
  data() {
    return {
      modal_p: false,
    }
  },
  methods: {
    modal_open() {
      this.modal_p = true
      this.$nextTick(() => this.$refs.message_input.focus())
    },
    message_send_process() {
      App.system_notification.message_send_all({from: js_global.current_user, message: this.message})
    },
  },
}
</script>

<style scoped>
</style>
