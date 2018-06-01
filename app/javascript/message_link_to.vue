<template lang="pug">
  span
    template(v-if="user_to")
      a(@click.prevent="modal_open")
        img.avatar_image(:src="user_to.avatar_url")
        | {{user_to.name}}
    template(v-else)
      slot(name="notify_to_all")
        .button.is-primary.is-outlined(@click.prevent="modal_open") 全体通知

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        header.modal-card-head
          p.modal-card-title
            template(v-if="user_to")
              | {{user_to.name}}に送信
            template(v-else)
              | 全体通知
        section.modal-card-body
          b-field(label="")
            input.input.is-large(type="text" v-model.trim="message" @keydown.enter="message_enter" autocomplete="off" ref="message_input")
        footer.modal-card-foot
          button.button.is-primary.is-outlined(@click="message_enter") 送信
          template(v-if="user_to")
            button.button.is-primary.is-outlined(@click="battle_request_to") 対局申し込み
</template>

<script>
export default {
  // name: "message_link_to",
  props: {
    user_to: { default: null, },
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
        if (this.user_to) {
          App.single_notification.message_send_to({from: js_global_params.current_chat_user, to: this.user_to, message: this.message})
          Vue.prototype.$toast.open({message: "送信OK", position: "is-top", type: "is-info", duration: 500})
        } else {
          App.system_notification.message_send_all({from: js_global_params.current_chat_user, message: this.message})
        }
      }
      this.message = ""
    },
    battle_request_to() {
      App.single_notification.battle_request_to({battle_request: {from_id: js_global_params.current_chat_user.id, to_id: this.user_to.id, message: this.message}})
      this.message = ""
    },
  },
}
</script>

<style scoped>
</style>
