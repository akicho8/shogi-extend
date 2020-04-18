<template lang="pug">
  .message_link_to.inline_iikanjino_yoko_ljust
    template(v-if="icon_show")
      img.avatar_image(@click.prevent="modal_open" :src="user_to.avatar_path" :class="`user_${user_to.id}`")
    template(v-if="name_show")
      span.user_name(@click.prevent="modal_open" v-text="user_to.name" :class="`user_${user_to.id}`")
    slot

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        .modal-card-head
          .modal-card-title
            a(:href="user_to.show_path")
              img.avatar_image_in_dialog(:src="user_to.avatar_path")
            a(:href="user_to.show_path")
              | {{user_to.name}}
            | さんに送信
            span.is-pulled-right.is-size-7
              | 勝率: {{user_to.win_ratio}}
              | &nbsp;
              | 勝ち: {{user_to.win_count}}
              | &nbsp;
              | 負け: {{user_to.lose_count}}
        .modal-card-body
          b-field(label="")
            textarea.textarea(v-model.trim="message" @keydown.enter="message_enter_handle" autocomplete="off" ref="message_input" rows="3")
        footer.modal-card-foot.space_between
          button.button(@click="message_post_button_handle") 送信
          button.button(@click="battle_request_to") 対局申し込み
</template>

<script>
import message_form_shared from "message_form_shared"

export default {
  mixins: [
    message_form_shared,
  ],

  props: {
    user_to:   { required: true },
    icon_show: { default: true },
    name_show: { default: true},
  },

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
      App.single_notification.message_send_to({from: js_global.current_user, to: this.user_to, message: this.message})
      this.$buefy.toast.open({message: "送信OK", position: "is-top", type: "is-info", duration: 500})
    },
    battle_request_to() {
      if (this.login_required()) {
        return
      }
      App.single_notification.battle_request_to({battle_request: {from_id: js_global.current_user.id, to_id: this.user_to.id, message: this.message}})
      this.message = ""
      this.$buefy.toast.open({message: "対局を申し込みました", position: "is-top", type: "is-info", duration: 500})
    },
  },
}
</script>

<style scoped>
</style>
