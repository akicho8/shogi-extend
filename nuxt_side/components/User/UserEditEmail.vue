<template lang="pug">
.UserEditEmail.has-background-white-bis
  b-loading(:active="$fetchState.pending")
  MainNavbar
    template(slot="start")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="save_handle") 保存

  MainSection
    .container
      .columns.is-centered
        .column
          b-field(label-position="on-border" label="メールアドレス")
            b-input(type="text" v-model.trim="new_email")
</template>

<script>
export default {
  name: "UserEditEmail",
  data() {
    return {
      new_email: "",
    }
  },
  meta() {
    return {
      title: this.page_title,
    }
  },
  fetch() {
    if (!this.g_current_user) {
      this.$nuxt.error({statusCode: 404, message: "ログインしてください"})
      return
    }
    return this.$axios.$get("/api/settings/email_fetch").then(e => {
      this.new_email = e.email
    })
  },
  methods: {
    // キャンセル
    cancel_handle() {
      this.$sound.play_click()
      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.back_to()
    },

    // 保存
    async save_handle() {
      this.$sound.play_click()

      const retv = await this.$axios.$put("/api/settings/email_update", {email: this.new_email})
      this.xnotice_run_all(retv)
      if (this.xnotice_has_error_p(retv)) {
        return
      }

      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.back_to()
    },
  },
  computed: {
    page_title() { return "メールアドレス変更" },
  },
}
</script>

<style scoped lang="sass">
.UserEditEmail
  min-height: 100vh

  .column
    max-width: 40rem
</style>
