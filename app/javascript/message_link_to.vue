<template lang="pug">
  span
    a.message_link_to(@click.prevent="modal_open" :class="`user_${user_to.id}`")
      img.avatar_image(:src="user_to.avatar_url")
      span.user_name
        | {{user_to.name}}

    b-modal(:active.sync="modal_p" has-modal-card)
      .modal-card
        header.modal-card-head
          p.modal-card-title
            a(:href="user_to.show_path")
              img.avatar_image_in_dialog(:src="user_to.avatar_url")
            a(:href="user_to.show_path")
              | {{user_to.name}}
            | さんに送信
            span.is-pulled-right.is-size-7
              | 勝率: {{user_to.win_ratio}}
              | &nbsp;
              | 勝ち: {{user_to.win_count}}
              | &nbsp;
              | 負け: {{user_to.lose_count}}
        section.modal-card-body
          b-field(label="")
            input.input.is-large(type="text" v-model.trim="message" @keydown.enter="message_enter" autocomplete="off" ref="message_input")
        footer.modal-card-foot
          button.button(@click="message_enter") 送信
          button.button(@click="battle_request_to") 対局申し込み
</template>

<script>
export default {
  props: {
    user_to: {
      required: true,
    },
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
      if (AppHelper.login_required()) {
        return
      }
      if (this.message !== "") {
        App.single_notification.message_send_to({from: js_global.current_user, to: this.user_to, message: this.message})
        Vue.prototype.$toast.open({message: "送信OK", position: "is-top", type: "is-info", duration: 500})
      }
      this.message = ""
      this.$refs.message_input.focus()
    },
    battle_request_to() {
      if (AppHelper.login_required()) {
        return
      }
      App.single_notification.battle_request_to({battle_request: {from_id: js_global.current_user.id, to_id: this.user_to.id, message: this.message}})
      this.message = ""
      Vue.prototype.$toast.open({message: "対局を申し込みました", position: "is-top", type: "is-info", duration: 500})
    },
  },
}
</script>

<style scoped>
</style>
