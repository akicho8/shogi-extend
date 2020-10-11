<template lang="pug">
.UserEmailEdit.has-background-white-bis
  b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
    template(slot="start")
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item.has-text-weight-bold(@click="save_handle") 保存

  .section
    .container
      .columns.is-centered
        .column.is-7-desktop
          b-field(label-position="on-border" label="メールアドレス")
            b-input(type="text" v-model.trim="new_email")
</template>

<script>
export default {
  name: "UserEmailEdit",
  data() {
    return {
      new_email: "",
    }
  },
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/settings/email_fetch").then(e => {
      this.new_email = e.email
    })
  },
  methods: {
    // キャンセル
    cancel_handle() {
      this.sound_play("click")
      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.$router.go(-1)
    },

    // 保存
    async save_handle() {
      this.sound_play("click")

      const params = {
        email: this.new_email,
      }

      const retval = await this.$axios.$put("/api/settings/email_update", params)
      this.notice_collector_run(retval)
      if (this.notice_collector_has_error(retval)) {
        return
      }

      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.$router.go(-1)
    },
  },
}
</script>

<style scoped lang="sass">
.UserEmailEdit
  min-height: 100vh

  .section
    padding-top: 2.25rem
</style>
