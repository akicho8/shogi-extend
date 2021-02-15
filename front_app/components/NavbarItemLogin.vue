<template lang="pug">
b-navbar-item.has-text-weight-bold(v-if="!g_current_user" @click="click_handle")
  | ログイン
</template>

<script>
export default {
  methods: {
    click_handle() {
      this.sound_play("click")
      this.sns_login_modal_open()
    },
  },
}
</script>
