<template lang="pug">
  span
    slot(name="notify_to_all")
      button.button.is-primary(@click.prevent="modal_open") 全体通知

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        header.modal-card-head
          p.modal-card-title
            | 全体通知
        section.modal-card-body
          b-field(label="")
            input.input.is-large(type="text" v-model.trim="message" @keydown.enter="message_enter" autocomplete="off" ref="message_input")
        footer.modal-card-foot
          button.button(@click="message_enter") 送信
</template>

<script>
export default {
  data() {
    return {
      modal_p: false,
      message: "",
    }
  },
  methods: {
    modal_open() {
      this.modal_p = true
      this.$nextTick(() => this.$refs.message_input.focus())
    },
    message_enter() {
      if (this.message !== "") {
        App.system_notification.message_send_all({from: js_global_params.current_user, message: this.message})
      }
      this.message = ""
      this.$refs.message_input.focus()
    },
  },
}
</script>

<style scoped>
</style>
