<template lang="pug">
b-navbar-dropdown.NavbarItemCurrentUser(:hoverable="false" arrowless right v-if="g_current_user")
  template(slot="label")
    .image
      img.is-rounded(:src="g_current_user.avatar_path")
  b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: g_current_user.id}}") プロフィール
  //- b-navbar-item(tag="nuxt-link" :to="{name: 'profile-edit'") プロフィール
  .navbar-divider
  b-navbar-item(@click="logout_handle") ログアウト
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex"

export default {
  name: "NavbarItemCurrentUser",
  methods: {
    ...mapActions("user", [
      "current_user_clear",
    ]),
    async logout_handle() {
      await this.current_user_clear()
      this.toast_ok("ログアウトしました")
    },
  },
}
</script>

<style lang="sass">
.NavbarItemCurrentUser
  img
    max-height: none
    height: 32px
    width: 32px
</style>
