<template lang="pug">
component(:is="component" class="NavbarItemLogin has-text-weight-bold" v-if="!g_current_user" @click="nuxt_login_modal_handle")
  | ログイン
</template>

<script>
export default {
  props: {
    component: { type: String, default: "b-navbar-item", },
  },
}
</script>
