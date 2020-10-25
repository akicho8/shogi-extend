<template lang="pug">
.UserEditSwarsUserKey.has-background-white-bis
  b-loading(:active="$fetchState.pending")
  MainNavbar
    template(slot="start")
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item.has-text-weight-bold(@click="save_handle") 保存

  MainSection
    .container
      .columns.is-centered
        .column
          b-field(label-position="on-border" label="ウォーズID")
            b-input(type="text" v-model.trim="new_swars_user_key")
</template>

<script>
export default {
  name: "UserEditSwarsUserKey",
  data() {
    return {
      new_swars_user_key: "",
    }
  },
  head() {
    return {
      title: this.page_title,
    }
  },
  fetch() {
    if (!this.g_current_user) {
      this.$nuxt.error({statusCode: 404, message: "ログインしてください"})
      return
    }
    return this.$axios.$get("/api/settings/swars_user_key_fetch").then(e => {
      this.new_swars_user_key = e.swars_user_key
    })
  },
  methods: {
    // キャンセル
    cancel_handle() {
      this.sound_play("click")
      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.back_to()
    },

    // 保存
    async save_handle() {
      this.sound_play("click")

      const params = {
        swars_user_key: this.new_swars_user_key,
      }

      const retv = await this.$axios.$put("/api/settings/swars_user_key_update", params)
      this.notice_collector_run(retv)
      if (this.notice_collector_has_error(retv)) {
        return
      }

      // this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
      this.back_to()
    },
  },
  computed: {
    page_title() {
      return "ウォーズIDの設定"
    },
  },
}
</script>

<style scoped lang="sass">
.UserEditSwarsUserKey
  min-height: 100vh

  .column
    max-width: 65ch
</style>
