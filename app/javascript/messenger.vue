<template lang="pug">
  span
    template(v-if="message_to")
      a(@click.prevent="modal_open") {{message_to.name}}
    template(v-else="")
      .button(@click.prevent="modal_open") 全体通知

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        header.modal-card-head
          p.modal-card-title
            template(v-if="message_to") {{message_to.name}}に送信
            template(v-else="") 全体通知
        section.modal-card-body
          b-field(label="")
            input.input.is-large(type="text" v-model.trim="message" @keydown.enter="message_enter" autocomplete="off" ref="message_input")
        footer.modal-card-foot
          button.button.is-primary(@click="message_enter") 送信
</template>

<script>
export default {
  props: {
    message_to: { default: null, },
  },
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
        if (this.message_to) {
          App.web_notification.message_send_to({from: lobby_app_params.current_chat_user, to: this.message_to, message: this.message})
        } else {
          App.system_notification.message_send_all({from: lobby_app_params.current_chat_user, message: this.message})
        }
        // Vue.prototype.$toast.open({message: "送信完了", position: "is-top", type: "is-info", duration: 1000})
      }
      this.message = ""
    },
  },
}
</script>

<style scoped>
</style>
