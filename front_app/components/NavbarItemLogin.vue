<template lang="pug">
component(:is="component" class="has-text-weight-bold" v-if="!g_current_user" @click="click_handle")
  | ログイン
</template>

<script>
export default {
  props: {
    component: { type: String, default: "b-navbar-item", },
  },
  methods: {
    click_handle() {
      this.sound_play("click")
      this.sns_login_modal_open()
    },
  },
}
</script>
